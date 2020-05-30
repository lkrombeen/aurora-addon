# Aurora Borealis
This addon gives additional functionalities for members of Aurora Borealis.
Items that have a priority entry will have it added to their tooltip.

You can addionally use the following commands:
- To check/post the priority on a single item: `/abp <item> <channel>`
	- item: link the item, shift-click to link it
	- channel: can be a number or a channel name: https://wowwiki.fandom.com/wiki/ChatTypeId
- To check/post the priority of the items in your currently opened loot window: `/abl <channel>`
	- channel: can be a number or a channel name: https://wowwiki.fandom.com/wiki/ChatTypeId
- To distribute loot via rolling you can use `\abr <prio> <item>`, the priority will be sent using a raid warning
	- prio (optional): leave blank to set prio to MS+1. `os` will set prio to offspec, a number 1-n will print the n-th priority you see in the tooltip.
	- item: link the item, shift-click to link it

# setup
1. Download this repository as a zip
2. Unzip the filder
3. Copy the directory "AuroraBorealis" to your WoW addon directory e.g. `C:\Program Files (x86)\World of Warcraft\_classic_\Interface\AddOns`