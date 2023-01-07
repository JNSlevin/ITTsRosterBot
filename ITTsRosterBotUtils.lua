local Utils = {}
ITTsRosterBot.Utils = Utils

Utils.memberCache = {}

d( "Should be assigning" )

function Utils:CacheMembers()
    for i = 1, GetNumGuilds() do
        local guildId = GetGuildId( i )
        local gname = GetGuildName( guildId )
        local total = GetNumGuildMembers( guildId )

        if gname ~= "" then
            for l = 1, total do
                local displayName, _, _, _, _ = GetGuildMemberInfo( guildId, l )

                if self.memberCache[displayName] == nil then
                    self.memberCache[displayName] = {}
                end

                table.insert( self.memberCache[displayName], gname )
            end
        end
    end
end

function Utils:HasValidHTag( needle, haystack, param )
    local condition = false

    if haystack and type( haystack ) == "string" then
        if haystack:find( "^|[hH]" ) then
            if string.find( haystack, "display" ) then
                haystack = ZO_LinkHandler_ParseLink( haystack )
            else
                haystack = GetItemLinkName( haystack )
            end
        end
    end

    needle = string.lower( needle )
    haystack = string.lower( haystack )

    if string.find( haystack, needle ) ~= nil then
        condition = true
    end

    return condition
end

function Utils:GetGuildDetails( settings )
    local details = {}
    details.id = 0
    details.index = 0

    if settings.index then
        details.id = GetGuildId( settings.index )
        details.index = settings.index
    elseif settings.id or settings.name then
        for i = 1, GetNumGuilds() do
            if (settings.id and settings.id == GetGuildId( i )) or
                (settings.name and settings.name == GetGuildName( GetGuildId( i ) )) then
                details.index = i
                details.id = GetGuildId( i )

                break
            end
        end
    end

    details.name = GetGuildName( details.id )

    return details
end

function Utils:GetGuildColor( guildIndex )
    local r, g, b = GetChatCategoryColor( _G["CHAT_CATEGORY_GUILD_" .. tostring( guildIndex )] )
    local colorObject = ZO_ColorDef:New( r, g, b )

    return {
        rgb = { r, g, b },
        hex = colorObject:ToHex(),
        zos = colorObject
    }
end

function Utils:BuildInlineGuildName( settings )
    local guild = self:GetGuildDetails( settings )

    local color = self:GetGuildColor( guild.index )

    return "|c" .. color.hex .. guild.name
end

function Utils:BuildInlineRelatedGuilds( displayName, guildId )
    -- d(displayName, guildId)

    local guilds = self.memberCache[displayName]
    -- local gtext  = ""
    local guildList = {}
    local currentGuild = { name = "" }

    if guildId then
        currentGuild = self:GetGuildDetails( { id = guildId } )
    end

    if guilds ~= nil then
        for k, v in pairs( guilds ) do
            if currentGuild.name ~= nil and v == currentGuild.name then
            else
                -- if gtext ~= "" then
                --     gtext = gtext .. ", "
                -- end
                -- gtext = gtext .. self:BuildInlineGuildName({ name = v })
                table.insert( guildList, self:BuildInlineGuildName( { name = v } ) )
            end
        end

        -- if gtext ~= "" then
        --     gtext = gtext
        -- end
    end

    return table.concat( guildList, "|cFFFFFF, " ), #guildList
end
