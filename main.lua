-- SMODS.Atlas({
--     key = "modicon",
--     path = "icon.png",
--     px = 32,
--     py = 32
-- }):register()

SMODS.Atlas({
    key = "turtlepack",
    path = "turtlepack.png",
    px = 71,
    py = 95
}):register()

SMODS.Sound({
    key = "exp",
    path = "exp.ogg"
}):register()

SMODS.Sound({
    key = "levelup",
    path = "levelup.ogg"
}):register()



sbp_config = SMODS.current_mod.config
mod_dir = ''..SMODS.current_mod.path

-- Get mod path and load other files
mod_dir = ''..SMODS.current_mod.path
if (SMODS.Mods["Pokermon"] or {}).can_load then
    pokermon_config = SMODS.Mods["Pokermon"].config
end

print("DEBUG")

--Load pets file
local pfiles = NFS.getDirectoryItems(mod_dir.."pets")
  for _, file in ipairs(pfiles) do
    sendDebugMessage ("The file is: "..file)
    local pets, load_error = SMODS.load_file("pets/"..file)
    if load_error then
      sendDebugMessage ("The error is: "..load_error)
    else
      local curr_pets = pets()
      if curr_pets.init then curr_pets:init() end
      
      if curr_pets.list and #curr_pets.list > 0 then
        for i, item in ipairs(curr_pets.list) do
            item.discovered = true
            if not item.key then
              item.key = item.name
            end
            if not item.config then
              item.config = {}
            end
            if not item.cost then
              item.cost = 3
            end
            if not item.soul_pos then
              item.soul_pos = {x = 100, y = 0}
            end
            if not item.in_pool then
              item.in_pool = function(self, args)
    return true, {allow_duplicates = true}
  end
            end
            SMODS.Joker(item)
          end
        end
      end
    end

    local function ease_sap_xp(card, value, from_eval)
    local old_xp = card.ability.extra.xp
    card.ability.extra.xp = card.ability.extra.xp + value
    local new_xp = card.ability.extra.xp
    for i=1, #G.jokers.cards do
        G.jokers.cards[i]:calculate_joker({xp_gained = true, other_card = G.jokers.cards[i]})
    end
    if (old_xp < 3 and new_xp >= 3) then
        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = localize("k_level_up_ex")
        })
        play_sound('sbp_levelup')
        for i=1, #G.jokers.cards do
          G.jokers.cards[i]:calculate_joker({level_up = true, other_card = card})
          card.ability.extra_value = 1
          card:set_cost()
        end
      elseif (old_xp < 6 and new_xp >= 6) then
        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = localize("k_level_up_ex")
        })
        play_sound('sbp_levelup')
        for i=1, #G.jokers.cards do
            G.jokers.cards[i]:calculate_joker({level_up = true, other_card = card})
            card.ability.extra_value = 2
            card:set_cost()
        end
    else play_sound('sbp_exp')
    end
end

G.FUNCS.can_merge_card = function(e)
    local card = e.config.ref_table
    if card.level == 3 then return end

    local index = nil
    for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] == card then
            index = i
            break
        end
    end

    if not index or not G.jokers.cards[index + 1] then return end

    local right_card = G.jokers.cards[index + 1]
    if right_card.config.center.key ~= card.config.center.key then return end
    if right_card.level == 3 then return end

    if card.ability.extra.xp < 6 and right_card.ability.extra.xp < 6 then
        e.config.colour = G.C.PURPLE
        e.config.button = 'merge_card'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.merge_card = function(e)
    local card = e.config.ref_table
    if card.level == 3 then return end

    local index = nil
    for i = 1, #G.jokers.cards do
        if G.jokers.cards[i] == card then
            index = i
            break
        end
    end

    if not index or not G.jokers.cards[index + 1] then return end

    local right_card = G.jokers.cards[index + 1]
    if right_card.config.center.key ~= card.config.center.key then return end
    if right_card.level == 3 then return end

    card:juice_up(0.8, 0.8)

    if right_card.edition and not card.edition then
        card:set_edition(right_card.edition)
    end

    right_card:start_dissolve({G.C.GOLD}, true)
    local xp_gain = right_card.ability.extra.xp or 0
    G.jokers:remove_card(right_card)
    ease_sap_xp(card, xp_gain)
end

level_sprites = function(card)
  local abbr = card.ability.extra
    if 6 > abbr.xp and abbr.xp >= 3 then abbr.level = 2 end
    if abbr.xp >= 6 then abbr.level = 3 end
    
    if card.area == G.jokers then
      if abbr.xp == 1 then
        card.children.floating_sprite:set_sprite_pos({ x = 1, y = 6 })
      elseif abbr.xp == 2 then
        card.children.floating_sprite:set_sprite_pos({ x = 2, y = 6 })
      elseif abbr.xp == 3 then abbr.level = 2
        card.children.floating_sprite:set_sprite_pos({ x = 3, y = 6 })
      elseif abbr.xp == 4 then
        card.children.floating_sprite:set_sprite_pos({ x = 4, y = 6 })
      elseif abbr.xp == 5 then
        card.children.floating_sprite:set_sprite_pos({ x = 5, y = 6 })
      elseif abbr.xp >= 6 then abbr.level = 3
        card.children.floating_sprite:set_sprite_pos({ x = 6, y = 6 })
      else
        card.children.floating_sprite:set_sprite_pos({x = 0, y = 6})
      end
    end
  end

buff_pet = function(card, health, attack)
  local abbr = card.ability.extra
  abbr.sap_health = math.min((abbr.sap_health + health), 50)
  abbr.sap_attack = math.min((abbr.sap_attack + attack), 50)
end

temp_buff_pet = function(card, health, attack)
  local abbr = card.ability.extra
  if health then
    if not abbr.temp_health then abbr.temp_health = health
    else abbr.temp_health = abbr.temp_health + health
    end
  end
  if attack then
    if not abbr.temp_attack then abbr.temp_attack = attack
    else abbr.temp_attack = abbr.temp_attack + attack
    end
  end
end

faint = function(self, card, context)
  if G.STATE == G.STATES.SHOP then
    remove(self, card, {})
  else
    G.E_MANAGER:add_event(Event({
        func = function()
        card.ability.fainted = G.GAME.round
        card:set_debuff()
        return true
        end
    })) 
  end
    --card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('poke_faint_ex'), colour = G.C.MULT})
end

local uidef_use_and_sell_buttons = G.UIDEF.use_and_sell_buttons
    function G.UIDEF.use_and_sell_buttons(card)
        local old_return = uidef_use_and_sell_buttons(card)
        if card.area and card.area.config.type == 'joker' and not card.config.center.consumeable then
            table.insert(old_return.nodes[1].nodes, {n=G.UIT.R, config={align='cl'}, nodes={
                {n=G.UIT.C, config={align = "cr"}, nodes={
                    {n=G.UIT.C, config={ref_table = card, align = "cr",padding = 0.1, r=0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = false, button = 'merge_card', func = 'can_merge_card'}, nodes={
                        {n=G.UIT.B, config = {w=0.1,h=0.6}},
                        {n=G.UIT.T, config={text = "Merge",colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
                    }}
                }}
            }})
        end
        return old_return
    end

--Load Debuff logic
local sprite, load_error = SMODS.load_file("functions/functions.lua")
if load_error then
  sendDebugMessage ("The error is: "..load_error)
else
  sprite()
end