_addon.name = 'tenzentimer'
_addon.version = '0.9.0.0'
_addon.author = 'yyoshisaur'
_addon.command = 'tenzentimer'

local logger = require('logger')
local res = require('resources')

local tenzen = {
    [3186] = {id=3186,english="Yaegasumi",japanese="八重霞",duration=45,icon='abilities/00205.png'},
    [3251] = {id=3251,english="Amatsu: Shirahadori",japanese="白羽取り",duration=30,icon='abilities/00206.png'},
}

local bushi = 'Tenzen'
local zone_sealion_id = 32

windower.register_event('load', function()
    lang = windower.ffxi.get_info().language:lower()
end)

windower.register_event('action', function(act)
    local mob_info = windower.ffxi.get_mob_by_id(act.actor_id)
    local zone = windower.ffxi.get_info().zone

    if mob_info and zone == zone_sealion_id and mob_info.name == bushi then
        if tenzen[act.param] then
            local skill_name = tenzen[act.param][lang]
            local skill_duration = tenzen[act.param].duration
            local icon = tenzen[act.param].icon
            local timer_commnad = 'timers c ""'..skill_name..'('..mob_info.name..')'..'"" '..skill_duration..' down '..icon
            windower.send_command(timer_commnad)
        end
    end
end)

windower.register_event('zone change', function(new_id, old_id)
    if old_id == zone_sealion_id and new_id ~= zone_sealion_id then
        local yae_timer_name = tenzen[3186][lang]..'('..bushi..')'
        local shira_timer_name = tenzen[3251][lang]..'('..bushi..')'
        local timer_delete_command = 'timers d '..yae_timer_name..';timers d '..shira_timer_name
        windower.send_command(timer_delete_command)
    end
end)