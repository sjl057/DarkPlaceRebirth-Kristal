local item, super = Class(Item, "pink_ribbon")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Pink Ribbon"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A cute hair ribbon that increases\nthe range bullets increase tension."

    -- Default shop price (sell price is halved)
    self.price = 100
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        defense = 1,

        graze_size = 0.2,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "GrazeArea"
    self.bonus_icon = "ui/menu/icon/up"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        susie = false,
        dess = false,
        ceroba = false
    }

    -- Character reactions
    self.reactions = {
        susie = "I said NO! C'mon already!",
        ralsei = "It's nice being dressed up...",
        noelle = "... feels familiar.",
        dess = "ew i hate pink things",
        jamm = "How adorable!",
        ["jamm+marcy"] = "It looks great on you, Marcy!",
        noel = "More tension?",
        ceroba = "A bit too small.",
    }
end

return item