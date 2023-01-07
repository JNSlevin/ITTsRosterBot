local Mail = {}
ITTsRosterBot.Mail = Mail

Mail.GuildList = {}

local function EditNoteDialogSetup(dialog, data)
    GetControl(dialog, "DisplayName"):SetText(data.displayName)
    GetControl(dialog, "GuildName"):SetText(ITTsRosterBot.Utils:BuildInlineGuildName({name = data.guildName}))
    -- GetControl(dialog, "GuildName"):SetColor( unpack(ITTsRosterBot.Utils:GetGuildColor( data.guildIndex ).rgb) )
    GetControl(dialog, "NoteEdit"):SetText(data.note)
end

function RB_EditMailNoteDialog_OnInitialized(self)

    d('Registered EDIT_MAIL_NOTE')

    ZO_Dialogs_RegisterCustomDialog("EDIT_MAIL_NOTE", {
        customControl = self,
        setup = EditNoteDialogSetup,
        title = {
            text = SI_EDIT_NOTE_DIALOG_TITLE,
        },
        buttons = {
            [1] = {
                control = GetControl(self, "Save"),
                text = SI_SAVE,
                callback = function(dialog)
                    local data = dialog.data
                    local note = GetControl(dialog, "NoteEdit"):GetText()

                    if(note ~= data.note) then
                        data.changedCallback(data.displayName, note, data.guildId, data.memberIndex)
                    end

                end,
            },
            
            [2] = {
                control = GetControl(self, "Cancel"),
                text = SI_DIALOG_CANCEL,
            }
        }
    })

end

function RB_NoteSettingsTest_OnInitialized(self)

    d('Registered EDIT_NOTE_TEST')

    ZO_Dialogs_RegisterCustomDialog("EDIT_NOTE_TEST", {
        customControl = self,
        setup = function(dialog, data) 

            -- dialog:SetWidth(800)

            -- GetControl(dialog, 'BGtest'):SetCenterColor( ZO_ColorDef:New(1,1,1,0):UnpackRGBA() )
            -- GetControl(dialog, 'BGtest'):SetEdgeColor( ZO_ColorDef:New(1,1,1,0):UnpackRGBA() )

            -- GetControl(dialog, '_Button_Icon'):SetColor( ZO_ColorDef:New( ITTsRosterBot.Utils:GetGuildColor(3).hex ):UnpackRGBA() )

        end,
        title = {
            text = 'GUILD RULE SETTINGS',
        },
        buttons = {
            [1] = {
                control = GetControl(self, "Done"),
                text = 'Done',
            }
        }
    })

    self:SetResizeToFitPadding(2,100)

    self:GetNamedChild('Done')

    for i = 1, 5 do
    
        local control = CreateControlFromVirtual('RB_NoteSettingsTest_GuildTab'..tostring(i),self,'ITTsRosterBot_GuildTab')
        local container = CreateControlFromVirtual('RB_NoteSettingsTest_GuildContainer'..tostring(i), self,'ITTRB_GuildSettings_ScrollContainer')
        local scrollChildContainer = container:GetNamedChild('ScrollChild')
        container:GetNamedChild('_Content'):SetParent( scrollChildContainer )
        container:GetNamedChild('_Content'):SetAnchor(TOPLEFT, scrollChildContainer, TOPLEFT, 4, 4)
        container:SetHidden(true)

        if i == 1 then
            control:SetAnchor(TOPLEFT,self,TOPLEFT, 0, 60)
            control:GetNamedChild('_BottomBorder'):SetHidden(true)
            control:GetNamedChild('_GuildColor'):SetHidden(false)
            container:SetHidden(false)
        else
            control:SetAnchor(TOPLEFT, self:GetNamedChild('_GuildTab'..tostring(i-1)), TOPRIGHT, 0, 0 )
            control:GetNamedChild('Name'):SetColor( ZO_ColorDef:New('333333'):UnpackRGBA() )
        end

        control:GetNamedChild('Name'):SetText( GetGuildName( GetGuildId(i) ) )
        container:GetNamedChild('_ContentGuildName'):SetText( GetGuildName( GetGuildId(i) )..' settings go here..' )
        control:GetNamedChild('_GuildColor'):SetCenterColor( ITTsRosterBot.Utils:GetGuildColor(i).zos:UnpackRGBA() )
        container:GetNamedChild('_Content'):SetCenterColor( ZO_ColorDef:New(0,0,0,0):UnpackRGBA() )
        container:GetNamedChild('_Content'):SetEdgeColor( ZO_ColorDef:New(0,0,0,0):UnpackRGBA() )
        control:GetNamedChild('_GuildColor'):SetEdgeColor( ZO_ColorDef:New(0,0,0,0):UnpackRGBA() )
        control:GetNamedChild('_TopBorder'):SetEdgeColor( ZO_ColorDef:New(0,0,0,0):UnpackRGBA() )
        control:GetNamedChild('_RightBorder'):SetEdgeColor( ZO_ColorDef:New(0,0,0,0):UnpackRGBA() )
        control:GetNamedChild('_BottomBorder'):SetEdgeColor( ZO_ColorDef:New(0,0,0,0):UnpackRGBA() )

        control:GetNamedChild('_Button')._section = i

        control:GetNamedChild('_Button'):SetHandler("OnClicked", function(control)

            for section = 1, 5 do

                RB_NoteSettingsTest:GetNamedChild('_GuildContainer'..tostring(section)):SetHidden(true)
                RB_NoteSettingsTest:GetNamedChild('_GuildTab'..tostring(section)..'_GuildColor'):SetHidden(true)
                RB_NoteSettingsTest:GetNamedChild('_GuildTab'..tostring(section)..'_BottomBorder'):SetHidden(false)
                RB_NoteSettingsTest:GetNamedChild('_GuildTab'..tostring(section)..'Name'):SetColor( ZO_ColorDef:New('333333'):UnpackRGBA() )

            end

            RB_NoteSettingsTest:GetNamedChild('_GuildContainer'..tostring(control._section)):SetHidden(false)
            RB_NoteSettingsTest:GetNamedChild('_GuildTab'..tostring(control._section)..'_GuildColor'):SetHidden(false)
            RB_NoteSettingsTest:GetNamedChild('_GuildTab'..tostring(control._section)..'_BottomBorder'):SetHidden(true)
            RB_NoteSettingsTest:GetNamedChild('_GuildTab'..tostring(control._section)..'Name'):SetColor( ZO_ColorDef:New('FFFFFF'):UnpackRGBA() )

        end)

    end

    -- RB_NoteSettingsTest_GuildTab2_RightBorder:SetWidth(2)
    self:GetNamedChild('_GuildTab5_RightBorder'):SetHidden(true)
    self:GetNamedChild('Divider'):SetAlpha(0)

end

SLASH_COMMANDS['/note-a'] = function()
    ZO_Dialogs_ShowDialog("EDIT_NOTE_TEST")
end

Mail.NoteCallback = function(displayName, note, guildId, index)
    SetGuildMemberNote(guildId, index, note)
end

local cachedMailOpen = ZO_MailInboxShared_UpdateInbox

function ZO_MailInboxShared_UpdateInbox(mailData, ...)
    
    cachedMailOpen(mailData, ...)
    
    local relatedGuilds = ITTsRosterBot.Utils.memberCache[mailData.senderDisplayName]
    local relatedGuildsLabel = ZO_MailInboxMessage:GetNamedChild('RelatedGuildsLabel')
    local relatedGuildsText = ZO_MailInboxMessage:GetNamedChild('RelatedGuilds')
    
    relatedGuildsText:SetText('')
    relatedGuildsLabel:SetHidden(true)
    
    for i = 1, 5 do
        Mail.GuildList[i]:SetHidden(true)
    end
    
    if relatedGuilds then
        
        relatedGuildsText:SetText(ITTsRosterBot.Utils:BuildInlineRelatedGuilds(mailData.senderDisplayName))
        relatedGuildsLabel:SetHidden(false)
        
        local labelIndex = 1
        
        for i = 1, #relatedGuilds do
            
            local guild = ITTsRosterBot.Utils:GetGuildDetails({name = relatedGuilds[i]})
            
            if DoesPlayerHaveGuildPermission(guild.id, GUILD_PERMISSION_NOTE_EDIT) then
                
                Mail.GuildList[labelIndex]:GetNamedChild('Text'):SetText(relatedGuilds[i])
                Mail.GuildList[labelIndex]:GetNamedChild('Text'):SetColor(unpack(ITTsRosterBot.Utils:GetGuildColor(guild.index).rgb))
                Mail.GuildList[labelIndex]:SetHidden(false)
                
                Mail.GuildList[labelIndex]:SetHandler("OnMouseUp", function(self, button, upInside, ctrl, alt, shift, command)
                
                    local numGuildMembers = GetNumGuildMembers(guild.id)
                    local currentNote = ''
                    local memberIndex = 0
                    
                    for guildMemberIndex = 1, numGuildMembers do
                        
                        local displayName, note = GetGuildMemberInfo(guild.id, guildMemberIndex)
                        if mailData.senderDisplayName == displayName then
                            currentNote = note
                            memberIndex = guildMemberIndex
                            break
                        end
                    end
                    
                    if upInside then
                        ZO_Dialogs_ShowDialog("EDIT_MAIL_NOTE", {
                            displayName = mailData.senderDisplayName,
                            note = currentNote,
                            guildName = relatedGuilds[i],
                            memberIndex = memberIndex,
                            guildId = guild.id,
                            guildIndex = guild.index,
                            changedCallback = Mail.NoteCallback
                        })
                    end
                    
                end)
                
                labelIndex = labelIndex + 1
                
            end
            
        end
        
        zo_callLater(function()
            
            Mail.GuildList[1]:ClearAnchors()
            
            if ZO_MailInboxMessageAttachmentsDivider:IsHidden() then
                Mail.GuildList[1]:SetAnchor(TOPLEFT, ZO_MailInboxMessageAttachmentsDivider, TOPLEFT, 0, -10)
            else
                Mail.GuildList[1]:SetAnchor(TOPLEFT, ZO_MailInboxMessageAttachments, BOTTOMLEFT, -30, 20)
            end
            
        end, 10)
        
    end
    
end

function Mail:Setup()

    for i = 1, 5 do
        
        local guildElement = CreateControlFromVirtual('ZO_MailInboxMessageRBGuild'..i, ZO_MailInboxMessage, 'ITTsRosterBotGUIMailGuildNote')
        
        if i == 1 then
            guildElement:SetAnchor(TOPLEFT, ZO_MailInboxMessageAttachments, BOTTOMLEFT, 0, 20)
        else
            guildElement:SetAnchor(TOPLEFT, ZO_MailInboxMessage:GetNamedChild('RBGuild'..tostring(i - 1)), BOTTOMLEFT, 0, 0)
        end
        
        guildElement:GetNamedChild('Text'):SetText('For Guild'..tostring(i))
        
        Mail.GuildList[i] = guildElement
        
    end

    local relatedGuildsLabel = ZO_MailInboxMessage:CreateControl('ZO_MailInboxMessageRelatedGuildsLabel', CT_LABEL)
    relatedGuildsLabel:SetAnchor(BELOW, ZO_MailInboxMessageReceivedLabel, BOTTOMLEFT, 0, 5)
    relatedGuildsLabel:SetText('Related Guilds:')
    relatedGuildsLabel:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_NORMAL))
    relatedGuildsLabel:SetFont('ZoFontWinH4')
    relatedGuildsLabel:SetHidden(true)

    local relatedGuildsText = ZO_MailInboxMessage:CreateControl('ZO_MailInboxMessageRelatedGuilds', CT_LABEL)
    relatedGuildsText:SetAnchor(TOPLEFT, relatedGuildsLabel, RIGHT, 5, -12)
    relatedGuildsText:SetDimensions(400, 55)
    relatedGuildsText:SetFont('ZoFontWinH4')
    relatedGuildsText:SetWrapMode(TEXT_WRAP_MODE_TRUNCATE)

    ZO_MailInboxMessageSubject:SetAnchor(TOPLEFT, ZO_MailInboxMessageRelatedGuilds, BOTTOMLEFT, -114, 8)

end