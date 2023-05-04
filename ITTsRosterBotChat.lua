local chat = {}
ITTsRosterBot.Chat = chat
local logger = LibDebugLogger( "RB Chat" )

--TODO: Add it to EVENT_PLAYER_ACTIVATED
--TODO: Add Icons after timestamp
--TODO: Make my own Formatter
--TODO: New formats do not get saved after reload?
function MyChatHandlersMessageChannelFormatter()
    local function myChatHandlersMessageChannelReceiver( channelID, from, text, isCustomerService, fromDisplayName )
        --your chat EVENT_CHAT_MESSAGE_CHANNEL callback function
        local newText = text .. " newText |t16:16:EsoUI/Art/ChatWindow/csIcon.dds|t"
        return newText
    end
    if pChat == nil then
        CHAT_ROUTER:RegisterMessageFormatter( EVENT_CHAT_MESSAGE_CHANNEL, myChatHandlersMessageChannelReceiver )
    else
        --pChat is loaded
        --!1!ATTENTION!!!
        --Do the following at EVENT_PLAYER_ACTIVATED after pChat has set CHAT_ROUTER:RegisterMessageFormatter(EVENT_CHAT_MESSAGE_CHANNEL, pChatChatHandlersMessageChannelReceiver)
        local formatters = CHAT_ROUTER:GetRegisteredMessageFormatters()
        local originalpChatFormatter = formatters[ EVENT_CHAT_MESSAGE_CHANNEL ]
        if originalpChatFormatter then
            --Post Hook pChat's EVENT_CHAT_MESSAGE_CHANNEL callbackFunction by re-applying the own handler function
            --which first calls pChat's function, and then your own code
            CHAT_ROUTER:RegisterMessageFormatter( EVENT_CHAT_MESSAGE_CHANNEL, function( ... )
                local messageTextOfpChatHandler = originalpChatFormatter( ... )
                --Do something with messageTextOfpChatHandler if you need to
                logger:Warn( messageTextOfpChatHandler )
                return "TEST || // ++ || TEST " .. messageTextOfpChatHandler -- myChatHandlersMessageChannelReceiver( ... )
            end )
        end
    end
end
