import AsyncStorage from '@react-native-async-storage/async-storage';
import NetInfo from '@react-native-community/netinfo';

const QUEUE_KEY = 'mutation_queue_v1';

type QueuedMutation = {
  id: string;
  key: string;
  payload: any;
  created_at: number;
};

export class MutationQueue {
  private queue: QueuedMutation[] = [];
  private processing = false;

  constructor() {
    this.init();
    // auto-retry on connectivity change
    NetInfo.addEventListener((state) => {
      if (state.isConnected) this.process();
    });
  }

  async init() {
    const raw = await AsyncStorage.getItem(QUEUE_KEY);
    this.queue = raw ? JSON.parse(raw) : [];
    // try process on startup if online
    const state = await NetInfo.fetch();
    if (state.isConnected) this.process();
  }

  private async persist() {
    await AsyncStorage.setItem(QUEUE_KEY, JSON.stringify(this.queue));
  }

  enqueue(item: Omit<QueuedMutation, 'created_at'>) {
    const queued: QueuedMutation = { ...item, created_at: Date.now() };
    this.queue.push(queued);
    this.persist();
    // try processing right away
    this.process();
  }

  async process() {
    if (this.processing) return;
    this.processing = true;

    try {
      // reload queue from storage in case it changed
      const raw = await AsyncStorage.getItem(QUEUE_KEY);
      this.queue = raw ? JSON.parse(raw) : this.queue;

      while (this.queue.length > 0) {
        const next = this.queue[0];

        try {
          // attempt to execute - caller should map keys to handlers
          await this.execute(next);
          // success: remove from queue
          this.queue.shift();
          await this.persist();
        } catch (err) {
          // if a transient error, break and retry later
          console.warn('Queued mutation failed, will retry later', err);
          break;
        }
      }
    } finally {
      this.processing = false;
    }
  }

  async execute(item: QueuedMutation) {
    throw new Error('No execute handler set for mutation queue');
  }

  setExecutor(fn: (item: QueuedMutation) => Promise<void>) {
    // eslint-disable-next-line @typescript-eslint/no-this-alias
    const self = this;
    this.execute = async function (item: QueuedMutation) {
      return fn(item);
    }.bind(self);
  }
}

export const mutationQueue = new MutationQueue();
