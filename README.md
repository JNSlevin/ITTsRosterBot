# ITTs Roster Bot

**Dependencies:** 
- [LibAddonMenu-2.0](https://www.esoui.com/downloads/info7-LibAddonMenu.html)
- [LibChatMessage](https://www.esoui.com/downloads/info2382-LibChatMessage.html)
- [LibGuildRoster](https://www.esoui.com/downloads/info2784-LibGuildRoster.html)
- [LibDebugLogger](https://esoui.com/downloads/info2275-LibDebugLogger.html)
- [LibTextFilter](https://esoui.com/downloads/info1311-LibTextFilter.html)

#### Other Addons from ITT:
- [ITTs Donation Bot](https://esoui.com/downloads/info2765-ITTsDonationBotITTDB.html) - Keeps track of guild donations.
- [ITTs Ghostwriter](https://www.esoui.com/downloads/info3208-ITTsGhostwriter.html) - Backup notes, send welcome mail, set note for newcomers.

## About

99% of this addon was developed by @Ghostbane! I (JN Slevin) have recently gotten permission from him to maintain (and finally upload) the addon. I am hoping to maintain it and add features and requests (to the best of my ability)
Roster Bot is an extensive addon that helps GMs and Staff track member information. We were hoping to fulfill most of the needs of a GM.

Modern, unintrusive and soon you wont be able to live without it!

#### Features

###### GuildRoster

- A whole new UI element which appends to the GuildRoster which lets you: 
    - see the most important information right away
    - choose which ranks you would like to select to show in the GuildRoster
    - choose the timeframe for the information (which will also change the timeframe for the Sales Addon of your choice, as well as ITTs Donation Bot)
    - An extensive text filter for the GuildRoster, which will help you:
        - search for Accountnames, Location, Notes and Alliance!
        - LibTextFilter allows us to use an immense amount of operators including:

            - ```' ' (space), '&': combine two words with AND ( Aldmeri Dominion will show you members with both words present )```
            - ``` '+', "/": combine two words with OR ( Aldmeri+Ebonheart will show you members from AD and EP )```
            - ```'-', '^': combine two words with AND, but negate the second one```
            - ```'!': negate the next expression ( !aldmeri will show you everyone from EP and DC) ```


- Replacing of the OfflineLocation ( which is redundant ) to the offline time

- Will be a slight yellow if the member is offline for longer than 7 days
- Will be yellow if the member is offline for longer than 14 days
 - Will be red if the member is offline for longer than 30 days



###### Member Tooltip

- Roster Bot will save the join date of newcomers
- The days in the tooltip, will be red for newcomers (adjustable in the settings, default is 7 days) and green old members (adjustable in the settings, default is 180 days)
- Related Guilds
    - It will show the guilds you and the member in question have in common.


###### Guild History

- History highlighting:
    - The guildhistory is now (optionally) highlighted, to help you see right away what is happening in your guild!
    - Available in the "General" and "Bank" Subcategories!
- History search:

    - On top of the History it will show you a search box, which will help you find events more easily
    - History selection:
    - In the "Bank" Subcategory, you may choose if you only want to see "Gold" Deposits and Withdrawals, "Item" Deposits and Withdrawals, both or none!


###### Applications

- Related Guilds
    - Guilds you have in common with the new applicant, will be shown under the application


###### Mails
- Related Guilds
    - Guilds you have in common with the sender, will be shown under the mail
    - You may also edit their notes in said guilds directly from the mail window ( which is immensely helpful if people want to let you know if they go on vacation etc )


#### Compatibility

Whilst these are not dependencies to make this addon work, chances are GMs + Staff will likely have these tools turned on, presented in their roster.



###### Supported 
- Arkadius' Trade Tools
- Master Merchant 3.6
- ITTs Donation Bot ( which is a dependency )

###### Not Supported 
( will work, but one or more features will be limited )
- Master Merchant before 3.6
- Shissu's Roster
- Advanced Member Tooltip ( this will overwrite the tooltip in our roster, which will cause our tooltip to not be shown )

#### More to come

Too long Trade GMs and Staff have had outdated tools or inconsistent experiences to do the daily maintenance required of running a functioning Trade Guild. Roster Bot is the third addition of many, in terms of helpful and modern tools to get the job done.


## About ITT 

Independent Trading Team is a trade alliance on PC-EU, always looking to provide a productive community for its traders and partners.

#### Known Issues

Master Merchant Integration is spotty atm. The Time Range options sometimes do not work as you expect. Sadly its a bigger issue. Will update once i find time.
