create or replace function public.delete_auth_user_with_diagnostics(p_user_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = pg_catalog, public, auth
as $$
declare
  v_deleted_count bigint;
  v_detail text;
  v_hint text;
  v_context text;
begin
  if p_user_id is null then
    return jsonb_build_object(
      'success', false,
      'sqlstate', '22004',
      'message', 'user id is required'
    );
  end if;

  delete from auth.users
  where id = p_user_id;

  get diagnostics v_deleted_count = row_count;

  return jsonb_build_object(
    'success', true,
    'deleted', v_deleted_count > 0
  );
exception
  when others then
    get stacked diagnostics
      v_detail = pg_exception_detail,
      v_hint = pg_exception_hint,
      v_context = pg_exception_context;

    return jsonb_build_object(
      'success', false,
      'sqlstate', sqlstate,
      'message', sqlerrm,
      'detail', nullif(v_detail, ''),
      'hint', nullif(v_hint, ''),
      'context', nullif(v_context, '')
    );
end;
$$;

revoke all on function public.delete_auth_user_with_diagnostics(uuid) from public, anon, authenticated;
grant execute on function public.delete_auth_user_with_diagnostics(uuid) to service_role;
