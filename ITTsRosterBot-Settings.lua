local LAM2 = LibAddonMenu2
local Settings = {}
ITTsRosterBot.Settings = Settings
local defaults = {
    settings = {
        guilds = {
            { name = "Guild Slot #1", id = 0, disabled = true, selected = false },
            { name = "Guild Slot #2", id = 0, disabled = true, selected = false },
            { name = "Guild Slot #3", id = 0, disabled = true, selected = false },
            { name = "Guild Slot #4", id = 0, disabled = true, selected = false },
            { name = "Guild Slot #5", id = 0, disabled = true, selected = false }
        },
        guildsCache = {
            { name = "Guild Slot #1", id = 0, disabled = true, selected = false },
            { name = "Guild Slot #2", id = 0, disabled = true, selected = false },
            { name = "Guild Slot #3", id = 0, disabled = true, selected = false },
            { name = "Guild Slot #4", id = 0, disabled = true, selected = false },
            { name = "Guild Slot #5", id = 0, disabled = true, selected = false }
        },
        services = {
            sales = "MM3"
        },
        historyHighlighting = true
    },
    UI = {
        history = {
            item = true,
            gold = true
        }
    },
    timeFrameIndex = 4,
    join_records = {}
}
-- --------------------
-- Create Settings
-- --------------------
local optionsData = {}
local lamPanelCreationInitDone = false
local panelData = {
    type = "panel",
    name = "ITT's Roster Bot",
    author = "ghostbane"
}

optionsData[#optionsData + 1] = {
    type = "header",
    name = "Guilds"
}

optionsData[#optionsData + 1] = {
    type = "description",
    title = "",
    text = [[]]
}

for i = 1, 5 do
    optionsData[#optionsData + 1] = {
        type = "checkbox",
        name = function()
            return ITTsRosterBot.db.settings.guilds[i].name
        end,
        tooltip = function()
            -- if db.settings.guilds[i].disabled then
            --     return "You do not have the correct permissions to scan this guild"
            -- else
            return "Turn scanning on or off for " .. ITTsRosterBot.db.settings.guilds[i].name
            -- end
        end,
        -- disabled = function() return db.settings.guilds[i].disabled end,
        getFunc = function()
            return ITTsRosterBot.db.settings.guilds[i].selected
        end,
        setFunc = function( value )
            ITTsRosterBot.db.settings.guilds[i].selected = value
        end,
        default = defaults.settings.guilds[i].selected,
        reference = "ITTsRosterBotSettingsGuild" .. tostring( i )
    }
end

optionsData[#optionsData + 1] = {
    type = "description",
    title = "",
    text = [[Whilst we try to handle things automatically, stuff can slip through. If the above guild list is not correct due to a recent change, you may need to run the /reloadui command]]
}

-- optionsData[#optionsData + 1] = {
--     type = "header",
--     name = "Notifications",
-- }

-- optionsData[#optionsData + 1] = {
--     type = "description",
--     title = "",
--     text = [[Notifications only apply for anything under the last 24 hours]]
-- }

optionsData[#optionsData + 1] = {
    type = "checkbox",
    name = "Guild History Highlighting",
    getFunc = function()
        return ITTsRosterBot.db.settings.historyHighlighting
    end,
    setFunc = function( value )
        ITTsRosterBot.db.settings.historyHighlighting = value
    end,
    default = defaults.settings.historyHighlighting
}

optionsData[#optionsData + 1] = {
    type = "header",
    name = "Services"
}

optionsData[#optionsData + 1] = {
    type = "description",
    title = "",
    text = [[]]
}

local _desc = true

local function makeITTDescription()
    local ITTDTitle = WINDOW_MANAGER:CreateControl( "ITTsRosterBotSettingsLogoTitle", ITT_RosterBotSettingsLogo, CT_LABEL )
    ITTDTitle:SetFont( "$(BOLD_FONT)|$(KB_18)|soft-shadow-thin" )
    ITTDTitle:SetText( "|Cfcba03INDEPENDENT TRADING TEAM" )
    ITTDTitle:SetDimensions( 240, 31 )
    ITTDTitle:SetHorizontalAlignment( 1 )
    ITTDTitle:SetAnchor( TOP, ITT_RosterBotSettingsLogo, BOTTOM, 0, 40 )

    local ITTDLabel = WINDOW_MANAGER:CreateControl( "ITTsRosterBotSettingsLogoTitleServer", ITTsRosterBotSettingsLogoTitle,
        CT_LABEL )
    ITTDLabel:SetFont( "$(MEDIUM_FONT)|$(KB_16)|soft-shadow-thick" )
    ITTDLabel:SetText( "|C646464PC EU" )
    ITTDLabel:SetDimensions( 240, 21 )
    ITTDLabel:SetHorizontalAlignment( 1 )
    ITTDLabel:SetAnchor( TOP, ITTsRosterBotSettingsLogoTitle, BOTTOM, 0, -5 )

    ITT_HideMePlsRoster:SetHidden( true )
end

local function LAMControlsCreatedCallbackFunc( pPanel )
    if pPanel ~= ITTsRosterBot.panel then
        return
    end

    if lamPanelCreationInitDone == true then
        return
    end

    --Do stuff here

    makeITTDescription()
    lamPanelCreationInitDone = true
end

local function endCredits()
    optionsData[#optionsData + 1] = {
        type = "description",
        title = "",
        text = [[]]
    }

    optionsData[#optionsData + 1] = {
        type = "description",
        title = "",
        text = [[ ]]
    }

    optionsData[#optionsData + 1] = {
        type = "description",
        title = "",
        text = [[ ]]
    }

    optionsData[#optionsData + 1] = {
        type = "texture",
        image = "ITTsRosterBot/itt-logo.dds",
        imageWidth = "192",
        imageHeight = "192",
        reference = "ITT_RosterBotSettingsLogo"
    }

    optionsData[#optionsData + 1] = {
        type = "checkbox",
        name = "HideMePls",
        getFunc = function()
            return false
        end,
        setFunc = function( value )
            return false
        end,
        default = false,
        disabled = true,
        reference = "ITT_HideMePlsRoster"
    }
end

function Settings:Initialize()
    local choices = { "None" }
    ITTsRosterBot.panel = LAM2:RegisterAddonPanel( "ITTsRosterBotOptions", panelData )
    for k, v in pairs( ITTsRosterBot.SalesAdapter.adapters ) do
        if ITTsRosterBot.SalesAdapter.adapters[k]:Available() then
            table.insert( choices, ITTsRosterBot.SalesAdapter.adapters[k].settingsLabel )
        end
    end

    optionsData[#optionsData + 1] = {
        type = "dropdown",
        name = "Sales Service",
        tooltip = "Choose a Sales Service for the Sidebar stats",
        choices = choices,
        getFunc = function()
            local choice = "None"

            if ITTsRosterBot.db.settings.services.sales ~= "None" then
                choice = ITTsRosterBot.SalesAdapter.adapters[ITTsRosterBot.db.settings.services.sales].settingsLabel
            end

            return choice
        end,
        setFunc = function( choice )
            if choice ~= "None" then
                for k, v in pairs( ITTsRosterBot.SalesAdapter.adapters ) do
                    if ITTsRosterBot.SalesAdapter.adapters[k]:Available() then
                        if ITTsRosterBot.SalesAdapter.adapters[k].settingsLabel == choice then
                            choice = ITTsRosterBot.SalesAdapter.adapters[k].name
                        else
                            ITTsRosterBot.SalesAdapter.adapters[k]:ShowUI()
                        end
                    end
                end
            end

            ITTsRosterBot.db.settings.services.sales = choice

            ITTsRosterBot.UI:ConfigureDropdown()
            ITTsRosterBot.UI:CheckServiceStatus()

            if ITTsRosterBot.db.settings.services.sales ~= "None" then
                ITTsRosterBot_SalesTotalTitle:SetText(
                    "|t20:20:EsoUI/Art/Guild/guild_tradingHouseAccess.dds|t SALES   |c66ffc2[ " ..
                    ITTsRosterBot.db.settings.services.sales .. " ]"
                )
            else
                ITTsRosterBot_SalesTotalTitle:SetText( "|t20:20:EsoUI/Art/Guild/guild_tradingHouseAccess.dds|t SALES" )
            end
        end
    }
    optionsData[#optionsData + 1] = {
        type = "slider",
        name = "Colorize Joindate #1",
        tooltip = "If the time of membership is |cff0000below|r this number it will colorize the duration since the join red.",
        getFunc = function()
            return ITTsRosterBot.db.newcomer
        end,
        setFunc = function( number )
            ITTsRosterBot.db.newcomer = number
        end,
        width = "full",
        disabled = false,
        min = 0,
        max = 14,
        step = 1
    }
    optionsData[#optionsData + 1] = {
        type = "slider",
        name = "Colorize Joindate #2",
        tooltip = "If the time of membership is |cff0000above|r this number it will colorize the duration since the join green.",
        getFunc = function()
            return ITTsRosterBot.db.oldNumber
        end,
        setFunc = function( number )
            ITTsRosterBot.db.oldNumber = number
        end,
        width = "full",
        disabled = false,
        min = 14,
        max = 180,
        step = 1
    }

    endCredits()

    CALLBACK_MANAGER:RegisterCallback( "LAM-PanelControlsCreated", LAMControlsCreatedCallbackFunc )
    LAM2:RegisterOptionControls( "ITTsRosterBotOptions", optionsData )
end
