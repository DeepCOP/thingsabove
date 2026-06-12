const { withDangerousMod } = require('expo/config-plugins');
const fs = require('fs');
const path = require('path');

const MODULAR_HEADER_PODS = [
  "pod 'GoogleUtilities', :modular_headers => true",
  "pod 'RecaptchaInterop', :modular_headers => true",
];

module.exports = function withGooglePodModularHeaders(config) {
  return withDangerousMod(config, [
    'ios',
    async (config) => {
      const podfilePath = path.join(config.modRequest.platformProjectRoot, 'Podfile');
      let podfile = fs.readFileSync(podfilePath, 'utf8');
      const missingPodLines = MODULAR_HEADER_PODS.filter((podLine) => !podfile.includes(podLine));

      if (missingPodLines.length === 0) {
        return config;
      }

      const podLines = missingPodLines.map((podLine) => `  ${podLine}`).join('\n');
      const targetStartPattern = /target ['"][^'"]+['"] do\n/;

      if (!targetStartPattern.test(podfile)) {
        throw new Error('Unable to add Google modular header pods: iOS target not found.');
      }

      podfile = podfile.replace(targetStartPattern, (targetStart) => `${targetStart}${podLines}\n`);
      fs.writeFileSync(podfilePath, podfile);

      return config;
    },
  ]);
};
