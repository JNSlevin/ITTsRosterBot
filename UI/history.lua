local History = {}
local logger = LibDebugLogger( ITTsRosterBot.name )
ITTsRosterBot.History = History

local AUTOMATIC_COLOR = ZO_ColorDef:New( "f54245" )

local function renderHistorySearch()
  local searchBoxContainer = CreateControlFromVirtual( "ITTsRosterBot_HistorySearch", ZO_GuildHistory, "ITTsRosterBot_Search" )
  local searchBox = searchBoxContainer:GetNamedChild( "Box" )
  -- searchBox:ClearAnchors()
  searchBox:SetWidth( 120, 30 )
  -- searchBox:SetMouseEnabled(true)
  searchBoxContainer:SetAnchor( LEFT, ZO_GuildHistoryActivityLogHeader, RIGHT, 20, 0 )

  searchBox:SetHandler(
    "OnTextChanged",
    function( control )
      ZO_EditDefaultText_OnTextChanged( control )

      if control:GetText() == "" then
        ITTsRosterBot_HistorySearchIcon:SetTexture( "esoui/art/lfg/lfg_tabicon_grouptools_up.dds" )
      else
        ITTsRosterBot_HistorySearchIcon:SetTexture( "esoui/art/lfg/lfg_tabicon_grouptools_down.dds" )
      end

      GUILD_HISTORY:RefreshFilters()
    end
  )

  ITTsRosterBot.UI.historySearchBox = searchBox

  local button = CreateControlFromVirtual( "ITTsRosterBotGoldFilter", ZO_GuildHistory, "ZO_ButtonBehaviorClickSound" )
  button:SetAnchor( LEFT, ITTsRosterBot_HistorySearch, RIGHT, 20, 0 )
  button:SetDimensions( 32, 32 )
  button:SetHidden( true )

  if (ITTsRosterBot.db.UI.history.gold) then
    button:SetPressedTexture( "EsoUI/Art/Guild/guildhistory_indexicon_guildstore_up.dds" )
    button:SetNormalTexture( "EsoUI/Art/Guild/guildhistory_indexicon_guildstore_down.dds" )
  else
    button:SetNormalTexture( "EsoUI/Art/Guild/guildhistory_indexicon_guildstore_up.dds" )
    button:SetPressedTexture( "EsoUI/Art/Guild/guildhistory_indexicon_guildstore_down.dds" )
  end

  button:SetHandler(
    "OnClicked",
    function( control )
      ITTsRosterBot.db.UI.history.gold = not ITTsRosterBot.db.UI.history.gold
      -- logger:Info('Gold:',ITTsRosterBot.db.UI.history.gold)

      if (ITTsRosterBot.db.UI.history.gold) then
        button:SetPressedTexture( "EsoUI/Art/Guild/guildhistory_indexicon_guildstore_up.dds" )
        button:SetNormalTexture( "EsoUI/Art/Guild/guildhistory_indexicon_guildstore_down.dds" )
      else
        button:SetNormalTexture( "EsoUI/Art/Guild/guildhistory_indexicon_guildstore_up.dds" )
        button:SetPressedTexture( "EsoUI/Art/Guild/guildhistory_indexicon_guildstore_down.dds" )
      end

      GUILD_HISTORY:RefreshFilters()
    end
  )

  button:SetHandler(
    "OnMouseEnter",
    function( control )
      InitializeTooltip( InformationTooltip )
      InformationTooltip:ClearAnchors()
      InformationTooltip:SetOwner( control, BOTTOM, 0, 0 )
      InformationTooltip:AddLine( "Gold filter", "", ZO_TOOLTIP_DEFAULT_COLOR:UnpackRGB() )
    end
  )
  button:SetHandler(
    "OnMouseExit",
    function( control )
      ClearTooltip( InformationTooltip )
    end
  )

  local itemButton = CreateControlFromVirtual( "ITTsRosterBotItemFilter", ZO_GuildHistory, "ZO_ButtonBehaviorClickSound" )
  itemButton:SetAnchor( LEFT, ITTsRosterBotGoldFilter, RIGHT, 20, 0 )
  itemButton:SetDimensions( 32, 32 )
  itemButton:SetHidden( true )

  if (ITTsRosterBot.db.UI.history.item) then
    itemButton:SetPressedTexture( "EsoUI/Art/Guild/guildhistory_indexicon_guildbank_up.dds" )
    itemButton:SetNormalTexture( "EsoUI/Art/Guild/guildhistory_indexicon_guildbank_down.dds" )
  else
    itemButton:SetNormalTexture( "EsoUI/Art/Guild/guildhistory_indexicon_guildbank_up.dds" )
    itemButton:SetPressedTexture( "EsoUI/Art/Guild/guildhistory_indexicon_guildbank_down.dds" )
  end

  itemButton:SetHandler(
    "OnClicked",
    function( control )
      ITTsRosterBot.db.UI.history.item = not ITTsRosterBot.db.UI.history.item

      if (ITTsRosterBot.db.UI.history.item) then
        itemButton:SetPressedTexture( "EsoUI/Art/Guild/guildhistory_indexicon_guildbank_up.dds" )
        itemButton:SetNormalTexture( "EsoUI/Art/Guild/guildhistory_indexicon_guildbank_down.dds" )
      else
        itemButton:SetNormalTexture( "EsoUI/Art/Guild/guildhistory_indexicon_guildbank_up.dds" )
        itemButton:SetPressedTexture( "EsoUI/Art/Guild/guildhistory_indexicon_guildbank_down.dds" )
      end

      GUILD_HISTORY:RefreshFilters()
    end
  )

  itemButton:SetHandler(
    "OnMouseEnter",
    function( control )
      InitializeTooltip( InformationTooltip )
      InformationTooltip:ClearAnchors()
      InformationTooltip:SetOwner( control, BOTTOM, 0, 0 )
      InformationTooltip:AddLine( "Item filter", "", ZO_TOOLTIP_DEFAULT_COLOR:UnpackRGB() )
    end
  )

  itemButton:SetHandler(
    "OnMouseExit",
    function( control )
      ClearTooltip( InformationTooltip )
    end
  )

  ITTsRosterBot.db.UI.history.button = button
  ITTsRosterBot.db.UI.history.itemButton = itemButton
end

local function formatDisplayNameLink( displayName )
  if displayName and not string.find( displayName, "|H1" ) then
    displayName = string.format( "|H1:display:%s|h%s|h", displayName, displayName )
  end

  return displayName
end

local function SetupGuildEvent( self, control, data )
  local bg = GetControl( control, "BG" )
  local sales = data.param5
  local item = data.param4
  local rarity = GetItemLinkQuality( item )
  local QualityColor = GetInterfaceColor( INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, rarity )
  -- logger:Info(data)
  if ITTsRosterBot.db.settings.historyHighlighting then
    -- bg:SetTexture("ITTsRosterBot/textures/listitem_highlight.dds")
    bg:SetTexture( "/esoui/art/miscellaneous/listitem_highlight.dds" )
    bg:SetTextureCoords( 0, 1, 0, 0.625 )
    if data.eventType == GUILD_EVENT_GUILD_PROMOTE then
      bg:SetColor( ZO_ColorDef:New( 238 / 255, 255 / 255, 0 / 255, 1 ):UnpackRGBA() )
    elseif data.eventType == GUILD_EVENT_GUILD_DEMOTE then
      bg:SetColor( ZO_ColorDef:New( 238 / 255, 255 / 255, 0 / 255, 0.5 ):UnpackRGBA() )
    elseif data.eventType == GUILD_EVENT_GUILD_KICKED then
      bg:SetColor( ZO_ColorDef:New( 255 / 255, 0 / 255, 0 / 255, 1 ):UnpackRGBA() )
    elseif data.eventType == GUILD_EVENT_GUILD_APPLICATION_ACCEPTED then
      bg:SetColor( ZO_ColorDef:New( 54 / 255, 139 / 255, 98 / 255, 1 ):UnpackRGBA() )
    elseif data.eventType == GUILD_EVENT_GUILD_INVITE then
      bg:SetColor( ZO_ColorDef:New( 54 / 255, 139 / 255, 98 / 255, 1 ):UnpackRGBA() )
    elseif data.eventType == GUILD_EVENT_GUILD_APPLICATION_DECLINED then
      bg:SetColor( ZO_ColorDef:New( 174 / 255, 67 / 255, 66 / 255, 1 ):UnpackRGBA() )
    elseif data.eventType == GUILD_EVENT_GUILD_JOIN then
      bg:SetColor( ZO_ColorDef:New( 0, 255 / 255, 0 / 255, 1 ):UnpackRGBA() )
    elseif data.eventType == GUILD_EVENT_GUILD_LEAVE then
      bg:SetColor( ZO_ColorDef:New( 255 / 255, 0 / 255, 0 / 255, 1 ):UnpackRGBA() )
    elseif data.eventType == GUILD_EVENT_MOTD_EDITED then
      bg:SetColor( ZO_ColorDef:New( 238 / 255, 255 / 255, 0 / 255, 1 ):UnpackRGBA() )
    elseif data.eventType == GUILD_EVENT_BANKGOLD_KIOSK_BID then
      bg:SetColor( ZO_ColorDef:New( 54 / 255, 139 / 255, 98 / 255, 1 ):UnpackRGBA() )
    elseif data.eventType == GUILD_EVENT_GUILD_KIOSK_PURCHASED then
      bg:SetColor( ZO_ColorDef:New( 56 / 255, 217 / 255, 139 / 255, 1 ):UnpackRGBA() )
    elseif data.eventType == GUILD_EVENT_BANKGOLD_KIOSK_BID_REFUND then
      bg:SetColor( ZO_ColorDef:New( 125 / 255, 183 / 255, 155 / 255, 1 ):UnpackRGBA() )
    elseif data.eventType == GUILD_EVENT_BANKGOLD_REMOVED then
      bg:SetColor( ZO_ColorDef:New( 255 / 255, 0 / 255, 0 / 255, 1 ):UnpackRGBA() )
    elseif data.eventType == GUILD_EVENT_BANKITEM_REMOVED then
      bg:SetColor( ZO_ColorDef:New( 255 / 255, 0 / 255, 0 / 255, 0.5 ):UnpackRGBA() )
    elseif data.eventType == GUILD_EVENT_BANKGOLD_ADDED then
      bg:SetColor( ZO_ColorDef:New( 0 / 255, 255 / 255, 0 / 255, 1 ):UnpackRGBA() )
    elseif data.eventType == GUILD_EVENT_BANKITEM_ADDED then
      bg:SetColor( ZO_ColorDef:New( 0 / 255, 255 / 255, 0 / 255, 0.5 ):UnpackRGBA() )
    else
      bg:SetColor( ZO_ColorDef:New( 0, 0, 0, 0 ):UnpackRGBA() )
    end

    --[[ if data.eventType == GUILD_EVENT_ITEM_SOLD then
      bg:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, rarity))
      bg:SetAlpha(0.5)
    end ]]
    if data.sortIndex and (data.sortIndex % 2) == 0 then
      bg:SetBlendMode( 1 )
    else
      bg:SetBlendMode( 0 )
    end
  else
    bg:SetColor( ZO_ColorDef:New( 0, 0, 0, 0 ):UnpackRGBA() )
    bg:SetBlendMode( 0 )
  end

  local description = self:FormatEvent( data.eventType, data.param1, data.param2, data.param3, data.param4, data.param5,
                                        data.param6 )
  local formattedTime = ZO_FormatDurationAgo( data.secsSinceEvent + GetGameTimeSeconds() - self.lastEventDataUpdateS )

  GetControl( control, "Description" ):SetText( description )
  GetControl( control, "Time" ):SetText( formattedTime )
end

local function renderHTags( data )
  if (
        (data.eventType == GUILD_EVENT_GUILD_INVITE or data.eventType == GUILD_EVENT_GUILD_JOIN) and data.param2 ~= nil and
        data.param1 ~= nil) then
    data.param1 = formatDisplayNameLink( data.param1 )
    data.param2 = formatDisplayNameLink( data.param2 )
  end

  if (data.eventType == GUILD_EVENT_GUILD_LEAVE and data.param1 ~= nil) then
    data.param1 = formatDisplayNameLink( data.param1 )
  end

  if (data.eventType == GUILD_EVENT_GUILD_KICKED and data.param1 ~= nil and data.param2 ~= nil) then
    data.param1 = formatDisplayNameLink( data.param1 )
    data.param2 = formatDisplayNameLink( data.param2 )
  end

  if (data.eventType == GUILD_EVENT_GUILD_PROMOTE and data.param1 ~= nil and data.param2 ~= nil and data.param3 ~= nil) then
    data.param1 = formatDisplayNameLink( data.param1 )
    data.param2 = formatDisplayNameLink( data.param2 )
  end

  if (data.eventType == GUILD_EVENT_GUILD_DEMOTE and data.param1 ~= nil and data.param2 ~= nil and data.param3 ~= nil) then
    data.param1 = formatDisplayNameLink( data.param1 )
    data.param2 = formatDisplayNameLink( data.param2 )
  end

  if ((data.eventType == GUILD_EVENT_BANKITEM_ADDED or data.eventType == GUILD_EVENT_BANKGOLD_ADDED) and data.param1 ~= nil) then
    data.param1 = formatDisplayNameLink( data.param1 )
  end

  if (
        (
          data.eventType == GUILD_EVENT_ITEM_SOLD or data.eventType == GUILD_EVENT_BANKITEM_REMOVED or
          data.eventType == GUILD_EVENT_BANKGOLD_REMOVED) and
        data.param1 ~= nil)
  then
    data.param1 = formatDisplayNameLink( data.param1 )
  end

  return data
end

local function GuildHistoryManagerFilterScrollList( self )
  local scrollData = ZO_ScrollList_GetDataList( self.list )
  local listWidth = self.list:GetNamedChild( "Contents" ):GetWidth()

  if GUILD_HISTORY:IsShowing() and GUILD_HISTORY.selectedCategory == 2 then
    ITTsRosterBot.db.UI.history.button:SetHidden( false )
    ITTsRosterBot.db.UI.history.itemButton:SetHidden( false )
  else
    ITTsRosterBot.db.UI.history.button:SetHidden( true )
    ITTsRosterBot.db.UI.history.itemButton:SetHidden( true )
  end

  ZO_ClearNumericallyIndexedTable( scrollData )

  local searchValue = ITTsRosterBot.UI.historySearchBox:GetText()

  for i = 1, #self.masterList do
    local data = self.masterList[ i ]

    if self.selectedSubcategory == nil or self.selectedSubcategory == data.subcategoryId then
      if (ITTsRosterBot.db.UI.history.gold == false and
            (data.eventType == GUILD_EVENT_BANKGOLD_ADDED or data.eventType == GUILD_EVENT_BANKGOLD_ADDED or
              --  data.eventType == GUILD_EVENT_BANKGOLD_GUILD_STORE_TAX or
              data.eventType == GUILD_EVENT_BANKGOLD_KIOSK_BID or
              data.eventType == GUILD_EVENT_BANKGOLD_KIOSK_BID_REFUND or
              -- data.eventType == GUILD_EVENT_BANKGOLD_PURCHASE_HERALDRY or
              data.eventType == GUILD_EVENT_BANKGOLD_REMOVED))
      then
      elseif (ITTsRosterBot.db.UI.history.item == false and
            (data.eventType == GUILD_EVENT_BANKITEM_ADDED or data.eventType == GUILD_EVENT_BANKITEM_REMOVED))
      then
      else
        -- if searchValue and (searchValue ~= '' or searchValue ~= nil) then
        if searchValue and string.len( searchValue ) > 0 then
          if (data.param1 and ITTsRosterBot.Utils:HasValidHTag( searchValue, data.param1, 1 )) or
              (data.param2 and ITTsRosterBot.Utils:HasValidHTag( searchValue, data.param2, 2 )) or
              (data.param3 and ITTsRosterBot.Utils:HasValidHTag( searchValue, data.param3, 3 )) or
              (data.param4 and ITTsRosterBot.Utils:HasValidHTag( searchValue, data.param4, 4 )) or
              (data.param5 and ITTsRosterBot.Utils:HasValidHTag( searchValue, data.param5, 5 )) or
              (data.param6 and ITTsRosterBot.Utils:HasValidHTag( searchValue, data.param6, 6 ))
          then
            local formattedData = renderHTags( data )

            table.insert( scrollData, ZO_ScrollList_CreateDataEntry( 1, formattedData ) )
          end
        else
          local formattedData = renderHTags( data )

          table.insert( scrollData, ZO_ScrollList_CreateDataEntry( 1, formattedData ) )
        end
      end
    end
  end

  local hasEntries = #scrollData > 0
  --self.noEntriesMessageLabel:SetHidden( hasEntries )
  --[[ if not hasEntries then
    self.noEntriesMessageLabel:SetText( ZO_GuildHistory_GetNoEntriesText( self.selectedCategory, self.selectedSubcategory,
                                                                          self.guildId ) )
  end ]]
end

-- From pChat
local function CopyToTextEntry( message )
  if string.len( message ) < 351 then
    if CHAT_SYSTEM.textEntry:GetText() == "" then
      CHAT_SYSTEM.textEntry:Open( message )
      ZO_ChatWindowTextEntryEditBox:SelectAll()
    end
  end
end

local function OnLinkClicked( link, button, text, color, linkType )
  if button ~= MOUSE_BUTTON_INDEX_RIGHT then
    return
  end

  if linkType ~= "display" then
    return
  end

  if link then
    local displayName = ZO_LinkHandler_ParseLink( link )

    AddMenuItem(
      "Copy " .. displayName,
      function()
        CopyToTextEntry( displayName )
      end
    )

    ShowMenu( ZO_Menu )
  end
end

function History:Setup()
  renderHistorySearch()

  LINK_HANDLER:RegisterCallback( LINK_HANDLER.LINK_MOUSE_UP_EVENT, OnLinkClicked )

  cachedHistoryFilterScrollList = GUILD_HISTORY.FilterScrollList
  GUILD_HISTORY.FilterScrollList = GuildHistoryManagerFilterScrollList

  GUILD_HISTORY.SetupGuildEvent = SetupGuildEvent
end
