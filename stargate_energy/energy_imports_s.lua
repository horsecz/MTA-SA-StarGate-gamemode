-- imports_s.lua: Importing functions from other resources; server-side

function array_push(...)
    return (exports.stargate_exports:array_push(...))
end

function array_remove(...)
    return (exports.stargate_exports:array_remove(...))
end