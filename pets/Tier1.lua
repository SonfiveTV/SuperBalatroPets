local ant = {
  name = "ant",
  pos = {x = 0, y = 0},
  config = {extra = {sap_health = 2, sap_attack = 2, health_mod = 1, attack_mod = 1, xp = 1, level = 1}},
  loc_vars = function(self, info_queue, card)
    local abbr = card.ability.extra
		return {vars = {(abbr.sap_health + (abbr.temp_health or 0)), (abbr.sap_attack + (abbr.temp_attack or 0))}}
  end,
  rarity = 1,
  tier = 1,
  atlas = "turtlepack",
  blueprint_compat = true,
  calculate = function(self, card, context)
    local abbr = card.ability.extra
    level_sprites(card)
    

    if context.cardarea == G.jokers and context.scoring_hand then
      if context.joker_main then
        return {
          message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}, 
          colour = G.C.CHIPS,
          chip_mod = abbr.sap_attack + (abbr.temp_attack or 0)
        }
      end
    end

    if context.after then
      temp_buff_pet(card, -(G.GAME.round_resets.ante), nil)
    end

    if abbr.sap_health + (abbr.temp_health or 0) == 0 then
      if #G.jokers.cards > 0 then
        local choice = pseudorandom_element(G.jokers.cards, pseudoseed('ant'))
        if G.STATE == G.STATES.SHOP then
          temp_buff_pet(choice, abbr.health_mod, abbr.attack_mod)
        else
          buff_pet(choice, abbr.health_mod, abbr.attack_mod)
        end
      end
      faint(card, card)
    end
  end,
}

local beaver = {
  name = "beaver",
  pos = {x = 1, y = 0},
  config = {extra = {sap_health = 1, sap_attack = 1, xp = 1, level = 1}},
  loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.sap_health, card.ability.extra.sap_attack, card.ability.extra.xp, card.ability.extra.level}}
  end,
  rarity = 1,
  tier = 1,
  atlas = "turtlepack",
  blueprint_compat = true,
  calculate = function(self, card, context)
    level_sprites(card)
  end,
}

local cricket = {
  name = "cricket",
  pos = {x = 2, y = 0},
  config = {extra = {sap_health = 1, sap_attack = 1, xp = 1, level = 1}},
  loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.sap_health, card.ability.extra.sap_attack, card.ability.extra.xp, card.ability.extra.level}}
  end,
  rarity = 1,
  tier = 1,
  atlas = "turtlepack",
  blueprint_compat = true,
  calculate = function(self, card, context)
    level_sprites(card)
  end,
}

local duck = {
  name = "duck",
  pos = {x = 3, y = 0},
  config = {extra = {sap_health = 1, sap_attack = 1, xp = 1, level = 1}},
  loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.sap_health, card.ability.extra.sap_attack, card.ability.extra.xp, card.ability.extra.level}}
  end,
  rarity = 1,
  tier = 1,
  atlas = "turtlepack",
  blueprint_compat = true,
  calculate = function(self, card, context)
    level_sprites(card)
  end,
}

local fish = {
  name = "fish",
  pos = {x = 4, y = 0},
  config = {extra = {sap_health = 1, sap_attack = 1, xp = 1, level = 1}},
  loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.sap_health, card.ability.extra.sap_attack, card.ability.extra.xp, card.ability.extra.level}}
  end,
  rarity = 1,
  tier = 1,
  atlas = "turtlepack",
  blueprint_compat = true,
  calculate = function(self, card, context)
    level_sprites(card)
  end,
}

local horse = {
  name = "horse",
  pos = {x = 5, y = 0},
  config = {extra = {sap_health = 1, sap_attack = 1, xp = 1, level = 1}},
  loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.sap_health, card.ability.extra.sap_attack, card.ability.extra.xp, card.ability.extra.level}}
  end,
  rarity = 1,
  tier = 1,
  atlas = "turtlepack",
  blueprint_compat = true,
  calculate = function(self, card, context)
    level_sprites(card)
  end,
}

local otter = {
  name = "otter",
  pos = {x = 6, y = 0},
  config = {extra = {sap_health = 1, sap_attack = 1, xp = 1, level = 1}},
  loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.sap_health, card.ability.extra.sap_attack, card.ability.extra.xp, card.ability.extra.level}}
  end,
  rarity = 1,
  tier = 1,
  atlas = "turtlepack",
  blueprint_compat = true,
  calculate = function(self, card, context)
    level_sprites(card)
  end,
}

local mosquito = {
  name = "mosquito",
  pos = {x = 7, y = 0},
  config = {extra = {sap_health = 1, sap_attack = 1, xp = 1, level = 1}},
  loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.sap_health, card.ability.extra.sap_attack, card.ability.extra.xp, card.ability.extra.level}}
  end,
  rarity = 1,
  tier = 1,
  atlas = "turtlepack",
  blueprint_compat = true,
  calculate = function(self, card, context)
    level_sprites(card)
  end,
}

local pig = {
  name = "pig",
  pos = {x = 8, y = 0},
  config = {extra = {sap_health = 1, sap_attack = 1, xp = 1, level = 1}},
  loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.sap_health, card.ability.extra.sap_attack, card.ability.extra.xp, card.ability.extra.level}}
  end,
  rarity = 1,
  tier = 1,
  atlas = "turtlepack",
  blueprint_compat = true,
  calculate = function(self, card, context)
    level_sprites(card)
  end,
}

local pigeon = {
  name = "pigeon",
  pos = {x = 9, y = 0},
  config = {extra = {sap_health = 1, sap_attack = 1, xp = 1, level = 1}},
  loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.sap_health, card.ability.extra.sap_attack, card.ability.extra.xp, card.ability.extra.level}}
  end,
  rarity = 1,
  tier = 1,
  atlas = "turtlepack",
  blueprint_compat = true,
  calculate = function(self, card, context)
    level_sprites(card)
  end,
}

return {name = "Turtle1", 
        list = {ant, beaver, cricket, duck, fish, horse, otter, mosquito, pig, pigeon},
}