---@class Workspace
---@field active_condition fun():boolean
---@field workloads {[string]:fun()}
local MainWorkspace = {}

---@type string
local MainWorkspaceName = ''

---@type {[string]:Workspace}
local ActiveWorkspaces = {}

---@type integer
local ActiveWorkspaceCount = 0

---@class Uwu
---@field setup fun(opts:{workspaces:{[string]:Workspace}})
---@field get_all_workloads fun():{[string]:fun()}
---@field run_workload fun(workload:string, workspace:string|nil)
---@field workspace_name fun():string|nil
---@type Uwu
local M = {}

---@param opts {workspaces:{[string]:Workspace}}
function M.setup(opts)
  opts = opts or {}

  if not opts.workspaces then
    return
  end

  for name, workspace in pairs(opts.workspaces) do
    if workspace.active_condition() then
      ActiveWorkspaces[name] = workspace
      ActiveWorkspaceCount = ActiveWorkspaceCount + 1
    end
  end

  if ActiveWorkspaceCount == 1 then
    local name, workspace = next(ActiveWorkspaces)
    if name and workspace and type(workspace) == 'table' then
      MainWorkspaceName = name
      MainWorkspace = workspace
      print('Active Workspace: ' .. name)
    end
  end
end

---@return {[string]:fun()}
function M.get_all_workloads()
  local allWorkloads = {}

  for workspaceName, workspace in pairs(ActiveWorkspaces) do
    for name, workload in pairs(workspace.workloads) do
      allWorkloads[workspaceName .. '::' .. name] = workload
    end
  end
  return allWorkloads
end

---Run workload
---@param workload string
---@param workspace string?
function M.run_workload(workload, workspace)
  workspace = workspace or MainWorkspaceName

  if not workspace then
    vim.api.nvim_echo({ { 'Error: No workspace specified', 'ErrorMsg' } }, true, {})
    return
  end

  local ws = ActiveWorkspaces[workspace]
  if not ws then
    vim.api.nvim_echo({ { 'Error: Workspace not found: ' .. workspace, 'ErrorMsg' } }, true, {})
    return
  end

  local wl = ws.workloads[workload]
  if not wl then
    vim.api.nvim_echo({ { 'Error: Workload not found: ' .. workload, 'ErrorMsg' } }, true, {})
    return
  end

  wl() 
end

---@return string|nil
function M.workspace_name()
  return MainWorkspaceName
end

return M
