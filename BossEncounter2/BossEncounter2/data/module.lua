local Root = BossEncounter2;


-- Provide basic operations to set up boss module in BE2 environment.

-- As such it is a core file.


-- --------------------------------------------------------------------
-- **                           Module data                          **
-- --------------------------------------------------------------------


local repository = { };


local list = { };


-- --------------------------------------------------------------------
-- **                         Module functions                       **
-- --------------------------------------------------------------------

-- ********************************************************************
-- * Root -> InsertToModule(insert, moduleName)                       *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> insert: the table that has its content inserted into target.  *
-- * >> moduleName: the name of the target module.                    *
-- ********************************************************************
-- * Add the content of a table into a module's table.                *
-- ********************************************************************

function Root.InsertToModule(insert, moduleName)
    if type(moduleName) ~= "string" or type(insert) ~= "table" then return; end
    local module = Root.GetOrNewModule(moduleName);
    local k, v;
    for k, v in pairs(insert) do
        if ( not module[k] ) then
            module[k] = v;
        end
    end
end

-- ********************************************************************
-- * Root -> AddSharedToBossModule(module)                            *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> module: the module to which add the shared functions.         *
-- ********************************************************************
-- * Gives common and shared methods / handlers to the module.        *
-- * Already existing methods / handlers will not be overriden.       *
-- ********************************************************************

function Root.AddSharedToBossModule(module)
    local k, v;
    for k, v in pairs(Root["Shared"]) do
        if type(v) == "function" and not module[k] then
            module[k] = v;
        end
    end

    -- Special case for the OnCombatEvent table.
    local combatTable = module.OnCombatEvent;
    if type(combatTable) ~= "table" then return; end

    for k, v in pairs(Root.Shared.OnCombatEvent) do
        if type(v) == "function" and not combatTable[k] then
            combatTable[k] = v;
        end
    end
end

-- ********************************************************************
-- * Root -> InstallBossModule(name, module[, avoidRepository])       *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> name: the name of the boss module.                            *
-- * >> module: the boss module table to be installed.                *
-- * >> avoidRepository: if true, the module will immediately be      *

-- * placed in the global table of BE2 and receive standard handlers  *

-- * instead of waiting to be pushed by the engine.                   *
-- * Useful and necessary for modules that activate themselves.       *
-- ********************************************************************
-- * Register a new boss module in the repository.                    *

-- * The boss module will not receive standard handlers from BE2      *
-- * until it is pushed into global table.                            *
-- ********************************************************************

function Root.InstallBossModule(name, module, avoidRepository)
    repository[name] = module;


    if ( avoidRepository ) then

        list[name] = 1;

        Root[name] = module;

  else

        list[name] = 0;

        Root[name] = nil;
    end



    -- Do some initialization stuff on the boss module.



    module.LOADED = false;
    module.MODNAME = name;

    module.running = false;
    module.data = nil;
    module.status = nil;

    module.avoidRepository = avoidRepository;
end


-- ********************************************************************
-- * Root -> PopModuleFromRepository(name)                            *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> name: the name of the boss module.                            *
-- ********************************************************************
-- * Pop a module from the repository and push it to the BE2          *
-- * namespace, allowing it to receive handlers.                      *

-- * Return true if the module has been successfully pushed in global *

-- * table of BE2 and is ready to be used.                            *
-- ********************************************************************

function Root.PopModuleFromRepository(name)
    if ( not list[name] ) then return false; end

    if ( list[name] == 1 ) then return true; end -- Already pushed.

    if ( list[name] == 0 ) then

        list[name] = 1;
 
        Root[name] = repository[name];

        return true;

    end

    return false;
end

-- ********************************************************************
-- * Root -> PushModuleToRepository(name)                             *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> name: the name of the boss module.                            *
-- ********************************************************************
-- * Push a module to the repository and pop it from the BE2          *
-- * namespace, preventing it from receiving handlers.                *

-- * Return true if the module has been successfully popped from      *

-- * global table of BE2.                                             *
-- ********************************************************************

function Root.PushModuleToRepository(name)
    if ( not list[name] ) then return false; end

    if ( list[name] == 0 ) then return true; end -- Already popped.

    if ( list[name] == 1 ) then

        list[name] = 0;

        Root[name] = nil;

        return true;

    end

    return false;
end


-- ********************************************************************
-- * Root -> TestModule(name[, engage, uid, extraTable])              *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> name: the name of the boss module.                            *

-- * >> engage: whether to engage the module or not.                  *

-- * >> uid: uid parameter to pass to the module.                     *

-- * >> extraTable: extra info table to pass to trigger handler.      *
-- ********************************************************************
-- * Test a boss module without requiring to push the module into     *
-- * global namespace first, this function will do it for you.        *
-- ********************************************************************

function Root.TestModule(name, engage, uid, extraTable)
    local ok = Root.PopModuleFromRepository(name);

    if ok then

        if engage then

            Root[name]:Test(uid or "player", extraTable);

      else

            Root[name]:OnTrigger(uid or "player", extraTable);

        end

    end
end


-- ********************************************************************
-- * Root -> InvokeRepositoryHandler(handlerName, ...)                *
-- ********************************************************************
-- * Arguments:                                                       *
-- * >> handlerName: the name of the handler to call.                 *
-- * >> ...: arguments to pass to the handler.                        *
-- ********************************************************************
-- * Execute an handler on all modules in the repository.             *
-- * Intended to be used for OnStart and OnEnterWorld.                *
-- ********************************************************************

function Root.InvokeRepositoryHandler(handlerName, ...)
    if type(handlerName) ~= "string" then return; end
    local k, v, h;
    for k, v in pairs(repository) do
        if type(v) == "table" and list[k] == 0 then
            h = v[handlerName];
            if type(h) == "function" then
                h(v, ...);
            end
        end
    end
end