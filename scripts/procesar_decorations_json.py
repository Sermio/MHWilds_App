import json

def transform_decorations(raw_data):
    transformed_data = {}
    
    for decoration in raw_data:
        name = decoration["decoration_name"]
        transformed_data[name] = decoration
    
    return transformed_data

# Datos de entrada
decorations = [
  {
    "decoration_name": "Adapt Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Adaptability +1",
    "decoration_description": "Grants protection against environmental damage, such as from heat or cold.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Ambush Jewel 2",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Ambush +1",
    "decoration_description": "Temporarily increases damage to large monsters with a successful Sneak Attack.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Antiblast Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Blast Resistance +1",
    "decoration_description": "Grants protection against blastblight.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Antidote Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Poison Resistance +1",
    "decoration_description": "Reduces damage while poisoned.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Antipara Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Paralysis Resistance +1",
    "decoration_description": "Reduces the duration of paralysis.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Artillery Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Artillery +1",
    "decoration_description": "Strengthens explosive attacks like shells, Wyvern's Fire, charge blade phial attacks, and Sticky Ammo.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Artillery Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Artillery +2",
    "decoration_description": "Strengthens explosive attacks like shells, Wyvern's Fire, charge blade phial attacks, and Sticky Ammo.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Artillery Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Artillery +3",
    "decoration_description": "Strengthens explosive attacks like shells, Wyvern's Fire, charge blade phial attacks, and Sticky Ammo.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Attack Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Attack Boost +1",
    "decoration_description": "Increases attack power.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Attack Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Attack Boost +2",
    "decoration_description": "Increases attack power.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Attack Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Attack Boost +3",
    "decoration_description": "Increases attack power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bandolier Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Tetrad Shot +1",
    "decoration_description": "Increases affinity of bowgun ammo/ coatings from the fourth shot and attack of the fourth and sixth shots.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Bandolier Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Tetrad Shot +2",
    "decoration_description": "Increases affinity of bowgun ammo/ coatings from the fourth shot and attack of the fourth and sixth shots.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Bandolier Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Tetrad Shot +3",
    "decoration_description": "Increases affinity of bowgun ammo/ coatings from the fourth shot and attack of the fourth and sixth shots.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bandolier/Blaze Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Tetrad Shot + 3\\n\\nFire Attack + 1",
    "decoration_description": "Increases affinity of bowgun ammo/ coatings from the fourth shot and attack of the fourth and sixth shots.\\nIncreases fire element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bandolier/Bolt Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Tetrad Shot + 3\\n\\nThunder Attack + 1",
    "decoration_description": "Increases affinity of bowgun ammo/ coatings from the fourth shot and attack of the fourth and sixth shots.\\nIncreases thunder element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bandolier/Dragon Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Tetrad Shot +3\\n\\nDragon Attack +1",
    "decoration_description": "Increases affinity of bowgun ammo/ coatings from the fourth shot and attack of the fourth and sixth shots.\\nIncreases dragon element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bandolier/Frost Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Tetrad Shot + 3\\n\\nIce Attack + 1",
    "decoration_description": "Increases affinity of bowgun ammo/ coatings from the fourth shot and attack of the fourth and sixth shots.\\nIncreases ice element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bandolier/Ironwall Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Tetrad Shot + 3\\n\\nGuard + 1",
    "decoration_description": "Increases affinity of bowgun ammo/ coatings from the fourth shot and attack of the fourth and sixth shots.\\nReduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bandolier/Precise Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Tetrad Shot + 3\\n\\nBallistics + 1",
    "decoration_description": "Increases affinity of bowgun ammo/ coatings from the fourth shot and attack of the fourth and sixth shots.\\nExtends the range in which ammo and arrows have maximum power",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bandolier/Stream Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Tetrad Shot +3\\n\\nWater Attack + 1",
    "decoration_description": "Increases affinity of bowgun ammo/ coatings from the fourth shot and attack of the fourth and sixth shots.\\nIncreases water element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Blast Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Blast Attack +1",
    "decoration_description": "Increases the rate of blast buildup. (Blast buildup has a maximum limit.)",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Blast Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Blast Attack +2",
    "decoration_description": "Increases the rate of blast buildup. (Blast buildup has a maximum limit.)",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Blast Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Blast Attack +3",
    "decoration_description": "Increases the rate of blast buildup. (Blast buildup has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Blastcoat Jewel 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Blast Functionality +1",
    "decoration_description": "Allows you to apply blast coatings.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Blaze Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Fire Attack +1",
    "decoration_description": "Increases fire element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Blaze Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Fire Attack +2",
    "decoration_description": "Increases fire element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Blaze Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Fire Attack +3",
    "decoration_description": "Increases fire element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Blaze/Bandolier Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Fire Attack + 3\\n\\nTetrad Shot + 1",
    "decoration_description": "Increases fire element attack power. (Elemental attack power has a maximum limit.)\\nIncreases affinity of bowgun ammo/ coatings from the fourth shot and attack of the fourth and sixth shots.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Blaze/Crit Elem Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Fire Attack + 3\\n\\nCritical Element + 1",
    "decoration_description": "Increases fire element attack power. (Elemental attack power has a maximum limit.)\\nIncreases elemental damage (fire, water, thunder, ice, dragon) when landing critical hits.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Blaze/Enhancer Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Fire Attack +3\\n\\nPower Prolonger + 1",
    "decoration_description": "Increases fire element attack power. (Elemental attack power has a maximum limit.)\\nAllows long swords, dual blades, insect glaives, switch axes, and charge blades to stay powered up longer.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Blaze/Focus Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Fire Attack + 3\\n\\nFocus + 1",
    "decoration_description": "Increases fire element attack power. (Elemental attack power has a maximum limit.)\\nIncreases the fill rate for weapons with gauges and the charge rate for weapons with charge attacks.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Blaze/Guardian Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Fire Attack + 3\\n\\nOffensive Guard + 1",
    "decoration_description": "Increases fire element attack power. (Elemental attack power has a maximum limit.)\\nTemporarily increases attack power after executing a perfectly/timed guard.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Blaze/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Fire Attack + 3\\n\\nHandicraft +1",
    "decoration_description": "Increases fire element attack power. (Elemental attack power has a maximum limit.)\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Blaze/Ironwall Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Fire Attack + 3\\n\\nGuard + 1",
    "decoration_description": "Increases fire element attack power. (Elemental attack power has a maximum limit.)\\nReduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Blaze/KO Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Fire Attack + 3\\n\\nSlugger + 1",
    "decoration_description": "Increases fire element attack power. (Elemental attack power has a maximum limit.)\\nMakes it easier to stun monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Blaze/Opener Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Fire Attack + 3\\n\\nOpening Shot +1",
    "decoration_description": "Increases fire element attack power. (Elemental attack power has a maximum limit.)\\nIncreases the bowgun's reload speed and increases the power of bullets when fully loaded.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Blaze/Precise Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Fire Attack + 3\\n\\nBallistics +1",
    "decoration_description": "Increases fire element attack power. (Elemental attack power has a maximum limit.)\\nExtends the range in which ammo and arrows have maximum power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Blaze/Quickswitch Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Fire Attack + 3\\n\\nRapid Morph + 1",
    "decoration_description": "Increases fire element attack power. (Elemental attack power has a maximum limit.)\\nIncreases switch speed and power for switch axes and charge blades.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Blaze/Rzr Sharp Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Fire Attack + 3\\n\\nRazor Sharp + 1",
    "decoration_description": "Increases fire element attack power. (Elemental attack power has a maximum limit.)\\nPrevents your weapon from losing sharpness.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Blaze/Shield Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Fire Attack +3\\n\\nGuard Up +1",
    "decoration_description": "Increases fire element attack power. (Elemental attack power has a maximum limit.)\\nAllows you to guard against ordinarily unblockable attacks.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Blunt Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Bludgeoner +1",
    "decoration_description": "Increases attack power when your weapon sharpness is low.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Blunt Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Bludgeoner +2",
    "decoration_description": "Increases attack power when your weapon sharpness is low.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Blunt Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Bludgeoner +3",
    "decoration_description": "Increases attack power when your weapon sharpness is low.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bolt Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Thunder Attack +1",
    "decoration_description": "Increases thunder element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Bolt Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Thunder Attack +2",
    "decoration_description": "Increases thunder element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Bolt Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Thunder Attack +3",
    "decoration_description": "Increases thunder element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bolt/Bandolier Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Thunder Attack + 3\\n\\nTetrad Shot + 1",
    "decoration_description": "Increases thunder element attack power. (Elemental attack power has a maximum limit.)\\nIncreases affinity of bowgun ammo/ coatings from the fourth shot and attack of the fourth and sixth shots.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bolt/Crit Elem Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Thunder Attack + 3\\n\\nCritical Element + 1",
    "decoration_description": "Increases thunder element attack power. (Elemental attack power has a maximum limit.)\\nIncreases elemental damage (fire, water, thunder, ice, dragon) when landing critical hits.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bolt/Enhancer Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Thunder Attack + 3\\n\\nPower Prolonger + 1",
    "decoration_description": "Increases thunder element attack power. (Elemental attack power has a maximum limit.)\\nAllows long swords, dual blades, insect glaives, switch axes, and charge blades to stay powered up longer.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bolt/Focus Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Thunder Attack + 3\\n\\nFocus + 1",
    "decoration_description": "Increases thunder element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bolt/Guardian Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Thunder Attack + 3\\n\\nOffensive Guard + 1",
    "decoration_description": "Increases thunder element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bolt/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Thunder Attack + 3\\n\\nHandicraft + 1",
    "decoration_description": "Increases thunder element attack power. (Elemental attack power has a maximum limit.)\\nIncreases the fill rate for weapons with gauges and the charge rate for weapons with charge attacks.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bolt/Ironwall Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Thunder Attack + 3\\n\\nGuard + 1",
    "decoration_description": "Increases thunder element attack power. (Elemental attack power has a maximum limit.)\\nReduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bolt/KO Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Thunder Attack + 3\\n\\nSlugger + 1",
    "decoration_description": "Increases thunder element attack power. (Elemental attack power has a maximum limit.)\\nMakes it easier to stun monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bolt/Opener Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Thunder Attack + 3\\n\\nOpening Shot + 1",
    "decoration_description": "Increases thunder element attack power. (Elemental attack power has a maximum limit.)\\nIncreases the bowgun's reload speed and increases the power of bullets when fully loaded.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bolt/Precise Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Thunder Attack + 3\\n\\nBallistics + 1",
    "decoration_description": "Increases thunder element attack power. (Elemental attack power has a maximum limit.)\\nExtends the range in which ammo and arrows have maximum power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bolt/Quickswitch Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Thunder Attack + 3\\n\\nRapid Morph + 1",
    "decoration_description": "Increases thunder element attack power. (Elemental attack power has a maximum limit.)\\nIncreases switch speed and power for switch axes and charge blades.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bolt/Rzr Sharp Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Thunder Attack + 3\\n\\nRazor Sharp + 1",
    "decoration_description": "Increases thunder element attack power. (Elemental attack power has a maximum limit.)\\nPrevents your weapon from losing sharpness.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bolt/Shield Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Thunder Attack + 3\\n\\nGuard Up + 1",
    "decoration_description": "Increases thunder element attack power. (Elemental attack power has a maximum limit.)\\nAllows you to guard against ordinarily unblockable attacks.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Bomber Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Bombardier +1",
    "decoration_description": "Increases the damage of explosive items.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Botany Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Botanist +1",
    "decoration_description": "Increases the quantity of herbs and other consumable items you gather.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Brace Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Flinch Free +1",
    "decoration_description": "Prevents knockbacks and other reactions to small damage.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Chain Jewel 3",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Burst +1",
    "decoration_description": "Continuously landing hits gradually increases attack and elemental attack. (Amount increased depends on weapon.)",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Challenger Jewel 3",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Agitator + 1",
    "decoration_description": "Increases attack power and affinity when large monsters become enraged.",
    "decoration_melding_cost": "Ancient Orb - Armor"
  },
  {
    "decoration_name": "Charge Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Charge Master +1",
    "decoration_description": "Increases element power and status buildup for charged attacks.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Charge Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Charge Master +2",
    "decoration_description": "Increases element power and status buildup for charged attacks.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Charge Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Charge Master +3",
    "decoration_description": "Increases element power and status buildup for charged attacks.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Charge Up Jewel 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Charge Up +2",
    "decoration_description": "Increases your power to induce stun when you hit a monster with a hammer's charged attack.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Charge Up/Attack Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Charge Up +1\\n\\nAttack Boost  +1",
    "decoration_description": "Increases your power to induce stun when you hit a monster with a hammer's charged attack.\\nIncreases attack power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Charge Up/Draw Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Charge Up +1\\n\\nCritical Draw + 1",
    "decoration_description": "Increases your power to induce stun when you hit a monster with a hammer's charged attack.\\nIncreases affinity when performing draw attacks. (Not effective while riding.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Charge Up/Expert Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Charge Up + 1\\n\\nCritical Eye + 1",
    "decoration_description": "Increases your power to induce stun when you hit a monster with a hammer's charged attack.\\nIncreases affinity.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Charge Up/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Charge Up +1\\n\\nHandicraft +1",
    "decoration_description": "Increases your power to induce stun when you hit a monster with a hammer's charged attack.\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Charge Up/KO Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Charge Up + 1\\n\\nSlugger + 1",
    "decoration_description": "Increases your power to induce stun when you hit a monster with a hammer's charged attack.\\nMakes it easier to stun monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Charge/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Charge Master + 1\\n\\nHandicraft + 1",
    "decoration_description": "Increases element power and status buildup for charged attacks.\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Charge/KO Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Charge Master + 1\\n\\nSlugger + 1",
    "decoration_description": "Increases element power and status buildup for charged attacks.\\nMakes it easier to stun monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Climber Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Cliffhanger +1",
    "decoration_description": "Decreases stamina depletion when climbing on vines.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Counter Jewel 2",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Counterstrike +1",
    "decoration_description": "Temporarily increases attack power after being knocked back.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Counterattack Jewel 3",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Adrenaline Rush + 1",
    "decoration_description": "Temporarily increases attack power after executing a perfectly/timed evade just as a monster attacks.",
    "decoration_melding_cost": "Mystery Orb - Armor"
  },
  {
    "decoration_name": "Crit Elem Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Element +3",
    "decoration_description": "Increases elemental damage (fire, water, thunder, ice, dragon) when landing critical hits.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Crit Elem/Blaze Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Element +3\\n\\nFire Attack +1",
    "decoration_description": "Increases elemental damage (fire, water, thunder, ice, dragon) when landing critical hits.\\nIncreases fire element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Crit Elem/Bolt Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Element + 3\\n\\nThunder Attack + 1",
    "decoration_description": "Increases elemental damage (fire, water, thunder, ice, dragon) when landing critical hits.\\nIncreases thunder element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Crit Elem/Dragon Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Element + 3\\n\\nDragon Attack + 1",
    "decoration_description": "Increases elemental damage (fire, water, thunder, ice, dragon) when landing critical hits.\\nIncreases dragon element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Crit Elem/Frost Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Element + 3\\n\\nIce Attack + 1",
    "decoration_description": "Increases elemental damage (fire, water, thunder, ice, dragon) when landing critical hits.\\nIncreases ice element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Crit Elem/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Element + 3\\n\\nHandicraft + 1",
    "decoration_description": "Increases elemental damage (fire, water, thunder, ice, dragon) when landing critical hits.\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Crit Elem/Ironwall Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Element + 3\\n\\nGuard + 1",
    "decoration_description": "Increases elemental damage (fire, water, thunder, ice, dragon) when landing critical hits.\\nReduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Crit Elem/KO Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Element + 3\\n\\nSlugger +1",
    "decoration_description": "Increases elemental damage (fire, water, thunder, ice, dragon) when landing critical hits.\\nMakes it easier to stun monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Crit Elem/Stream Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Element +3\\n\\nWater Attack +1",
    "decoration_description": "Increases elemental damage (fire, water, thunder, ice, dragon) when landing critical hits.\\nIncreases water element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Crit Element Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Critical Element +1",
    "decoration_description": "Increases elemental damage (fire, water, thunder, ice, dragon) when landing critical hits.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Crit Element Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Critical Element +2",
    "decoration_description": "Increases elemental damage (fire, water, thunder, ice, dragon) when landing critical hits.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Crit Element/Precise Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Element +3\\n\\nBallistics + 1",
    "decoration_description": "Increases elemental damage (fire, water, thunder, ice, dragon) when landing critical hits.\\nExtends the range in which ammo and arrows have maximum power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Crit Stat Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Status +3",
    "decoration_description": "Increases abnormal status effects (paralysis, poison, sleep, blast) when landing critical hits.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Crit Stat/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Status + 3\\n\\nHandicraft + 1",
    "decoration_description": "Increases abnormal status effects (paralysis, poison, sleep, blast) when landing critical hits.\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Crit Stat/Ironwall Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Status + 3\\n\\nGuard +1",
    "decoration_description": "Increases abnormal status effects (paralysis, poison, sleep, blast) when landing critical hits.\\nReduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Crit Stat/Precise Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Status +3\\n\\nBallistics + 1",
    "decoration_description": "Increases abnormal status effects (paralysis, poison, sleep, blast) when landing critical hits.\\nExtends the range in which ammo and arrows have maximum power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Crit Status Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Critical Status +1",
    "decoration_description": "Increases abnormal status effects (paralysis, poison, sleep, blast) when landing critical hits.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Crit Status Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Critical Status +2",
    "decoration_description": "Increases abnormal status effects (paralysis, poison, sleep, blast) when landing critical hits.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Crit Status/KO Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Status + 3\\n\\nSlugger + 1",
    "decoration_description": "Increases abnormal status effects (paralysis, poison, sleep, blast) when landing critical hits.\\nMakes it easier to stun monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Critical Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Critical Boost +1",
    "decoration_description": "Increases the damage of critical hits.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Critical Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Critical Boost +2",
    "decoration_description": "Increases the damage of critical hits.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Critical Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Boost +3",
    "decoration_description": "Increases the damage of critical hits.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Def Lock Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Iron Skin +1",
    "decoration_description": "Grants protection against defense down.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Defense Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Defense Boost +1",
    "decoration_description": "Increases defense. Also improves resistances at higher levels.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Destroyer Jewel 2",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Partbreaker +1",
    "decoration_description": "Makes it easier to break large monster parts, and increases damage dealt when destroying a wound with a Focus Strike.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Dive Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Leap of Faith +1",
    "decoration_description": "Allows you to do a dive/evade when facing towards large monsters and extends the dive/evade distance.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Dragon Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Dragon Attack +1",
    "decoration_description": "Increases dragon element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Dragon Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Dragon Attack +2",
    "decoration_description": "Increases dragon element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Dragon Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Dragon Attack +3",
    "decoration_description": "Increases dragon element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Dragon Res Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Dragon Resistance +1",
    "decoration_description": "Increases dragon resistance. Also improves defense at higher levels.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Dragon/Bandolier Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Dragon Attack +3\\n\\nTetrad Shot + 1",
    "decoration_description": "Increases dragon element attack power. (Elemental attack power has a maximum limit.)\\nIncreases affinity of bowgun ammo/ coatings from the fourth shot and attack of the fourth and sixth shots",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Dragon/Crit Elem Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Dragon Attack + 3\\n\\nCritical Element + 1",
    "decoration_description": "Increases dragon element attack power. (Elemental attack power has a maximum limit.)\\nIncreases elemental damage (fire, water, thunder, ice, dragon) when landing critical hits.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Dragon/Enhancer Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Dragon Attack +3\\n\\nPower Prolonger +1",
    "decoration_description": "Increases dragon element attack power. (Elemental attack power has a maximum limit.)\\nAllows long swords, dual blades, insect glaives, switch axes, and charge blades to stay powered up longer.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Dragon/Focus Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Dragon Attack +3\\n\\nFocus +1",
    "decoration_description": "Increases dragon element attack power. (Elemental attack power has a maximum limit.)\\nIncreases the fill rate for weapons with gauges and the charge rate for weapons with charge attacks.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Dragon/Guardian Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Dragon Attack + 3\\n\\nOffensive Guard + 1",
    "decoration_description": "Increases dragon element attack power. (Elemental attack power has a maximum limit.)\\nTemporarily increases attack power after executing a perfectly/timed guard.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Dragon/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Dragon Attack + 3\\n\\nHandicraft + 1",
    "decoration_description": "Increases dragon element attack power. (Elemental attack power has a maximum limit.)\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Dragon/Ironwall Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Dragon Attack + 3\\n\\nGuard + 1",
    "decoration_description": "Increases dragon element attack power. (Elemental attack power has a maximum limit.)\\nReduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Dragon/KO Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Dragon Attack + 3\\n\\nSlugger + 1",
    "decoration_description": "Increases dragon element attack power. (Elemental attack power has a maximum limit.)\\nMakes it easier to stun monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Dragon/Opener Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Dragon Attack +3\\n\\nOpening Shot +1",
    "decoration_description": "Increases dragon element attack power. (Elemental attack power has a maximum limit.)\\nIncreases the bowgun's reload speed and increases the power of bullets when fully loaded.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Dragon/Precise Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Dragon Attack + 3\\n\\nBallistics + 1",
    "decoration_description": "Increases dragon element attack power. (Elemental attack power has a maximum limit.)\\nExtends the range in which ammo and arrows have maximum power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Dragon/Quickswitch Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Dragon Attack + 3\\n\\nRapid Morph + 1",
    "decoration_description": "Increases dragon element attack power. (Elemental attack power has a maximum limit.)\\nIncreases switch speed and power for switch axes and charge blades.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Dragon/Rzr Sharp Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Dragon Attack + 3\\n\\nRazor Sharp + 1",
    "decoration_description": "Increases dragon element attack power. (Elemental attack power has a maximum limit.)\\nPrevents your weapon from losing sharpness.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Dragon/Shield Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Dragon Attack + 3\\n\\nGuard Up + 1",
    "decoration_description": "Increases dragon element attack power. (Elemental attack power has a maximum limit.)\\nAllows you to guard against ordinarily unblockable attacks.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Drain Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Stamina Thief +1",
    "decoration_description": "Increases certain attacks' ability to exhaust monsters.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Drain Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Stamina Thief +2",
    "decoration_description": "Increases certain attacks' ability to exhaust monsters.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Drain Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Stamina Thief +3",
    "decoration_description": "Increases certain attacks' ability to exhaust monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Draincoat Jewel 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Exhaust Functionality +2",
    "decoration_description": "Allows you to apply exhaust coatings.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Draw Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Critical Draw +1",
    "decoration_description": "Increases affinity when performing draw attacks. (Not effective while riding.)",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Draw Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Critical Draw +2",
    "decoration_description": "Increases affinity when performing draw attacks. (Not effective while riding.)",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Draw Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Draw +3",
    "decoration_description": "Increases affinity when performing draw attacks. (Not effective while riding.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Earplugs Jewel 2",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Earplugs +1",
    "decoration_description": "Grants protection from large monsters' roars.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Enduring Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Item Prolonger +1",
    "decoration_description": "Extends the duration of some item effects.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Enhancer Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Power Prolonger +1",
    "decoration_description": "Allows long swords, dual blades, insect glaives, switch axes, and charge blades to stay powered up longer.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Enhancer Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Power Prolonger +2",
    "decoration_description": "Allows long swords, dual blades, insect glaives, switch axes, and charge blades to stay powered up longer.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Enhancer Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Power Prolonger +3",
    "decoration_description": "Allows long swords, dual blades, insect glaives, switch axes, and charge blades to stay powered up longer.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Enhancer/Blaze Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Power Prolonger + 3\\n\\nFire Attack + 1",
    "decoration_description": "Allows long swords, dual blades, insect glaives, switch axes, and charge blades to stay powered up longer.\\nIncreases fire element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Enhancer/Bolt Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Power Prolonger + 3\\n\\nThunder Attack + 1",
    "decoration_description": "Allows long swords, dual blades, insect glaives, switch axes, and charge blades to stay powered up longer.\\nIncreases thunder element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Enhancer/Dragon Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Power Prolonger + 3\\n\\nDragon Attack + 1",
    "decoration_description": "Allows long swords, dual blades, insect glaives, switch axes, and charge blades to stay powered up longer.\\nIncreases dragon element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Enhancer/Frost Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Power Prolonger + 3\\n\\nIce Attack + 1",
    "decoration_description": "Allows long swords, dual blades, insect glaives, switch axes, and charge blades to stay powered up longer.\\nIncreases ice element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Enhancer/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Power Prolonger + 3\\n\\nHandicraft + 1",
    "decoration_description": "Allows long swords, dual blades, insect glaives, switch axes, and charge blades to stay powered up longer.\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Enhancer/Stream Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Power Prolonger + 3\\n\\nWater Attack + 1",
    "decoration_description": "Allows long swords, dual blades, insect glaives, switch axes, and charge blades to stay powered up longer.\\nIncreases water element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Escape Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Bind Resistance +1",
    "decoration_description": "Grants protection against webbed status and frostblight.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Evasion Jewel 2",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Evade Window +1",
    "decoration_description": "Extends the invulnerability period when evading.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Expert Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Critical Eye +1",
    "decoration_description": "Increases affinity.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Expert Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Critical Eye +2",
    "decoration_description": "Increases affinity.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Expert Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Critical Eye +3",
    "decoration_description": "Increases affinity.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Fire Res Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Fire Resistance +1",
    "decoration_description": "Increases fire resistance. Also improves defense at higher levels.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Flash Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Blindsider +1",
    "decoration_description": "Improves the effectiveness of flash attacks and items.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Flawless Jewel 2",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Peak Performance +2",
    "decoration_description": "Increases attack when your health is full.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Flayer Jewel 3",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Flayer +1",
    "decoration_description": "Makes it easier to inflict wounds. Upon inflicting enough damage, also deals additional non/elemental damage.",
    "decoration_melding_cost": "Ancient Orb - Armor"
  },
  {
    "decoration_name": "Flight Jewel 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Airborne +1",
    "decoration_description": "Increases the damage caused by jumping attacks.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Flight/Attack Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Airborne + 1\\n\\nAttack Boost + 1",
    "decoration_description": "Increases the damage caused by jumping attacks.\\nIncreases attack power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Flight/Draw Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Airborne + 1\\n\\nCritical Draw + 1",
    "decoration_description": "Increases the damage caused by jumping attacks.\\nIncreases affinity when performing draw attacks. (Not effective while riding.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Flight/Expert Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Airborne + 1\\n\\nCritical Eye + 1",
    "decoration_description": "Increases the damage caused by jumping attacks.\\nIncreases affinity.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Flight/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Airborne + 1\\n\\nHandicraft + 1",
    "decoration_description": "Increases the damage caused by jumping attacks.\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Focus Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Focus +1",
    "decoration_description": "Increases the fill rate for weapons with gauges and the charge rate for weapons with charge attacks.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Focus Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Focus +2",
    "decoration_description": "Increases the fill rate for weapons with gauges and the charge rate for weapons with charge attacks.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Focus Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Focus +3",
    "decoration_description": "Increases the fill rate for weapons with gauges and the charge rate for weapons with charge attacks.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Focus/Blaze Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Focus + 3\\n\\nFire Attack + 1",
    "decoration_description": "Increases the fill rate for weapons with gauges and the charge rate for weapons with charge attacks.\\nIncreases fire element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Focus/Bolt Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Focus + 3\\n\\nThunder Attack + 1",
    "decoration_description": "Increases the fill rate for weapons with gauges and the charge rate for weapons with charge attacks.\\nIncreases thunder element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Focus/Dragon Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Focus + 3\\n\\nDragon Attack + 1",
    "decoration_description": "Increases the fill rate for weapons with gauges and the charge rate for weapons with charge attacks.\\nIncreases dragon element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Focus/Frost Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Focus + 3\\n\\nIce Attack + 1",
    "decoration_description": "Increases the fill rate for weapons with gauges and the charge rate for weapons with charge attacks.\\nIncreases ice element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Focus/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Focus + 3\\n\\nHandicraft +1",
    "decoration_description": "Increases the fill rate for weapons with gauges and the charge rate for weapons with charge attacks.\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Focus/KO Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Focus + 3\\n\\nSlugger + 1",
    "decoration_description": "Increases the fill rate for weapons with gauges and the charge rate for weapons with charge attacks.\\nMakes it easier to stun monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Focus/Precise Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Focus + 3\\n\\nBallistics + 1",
    "decoration_description": "Increases the fill rate for weapons with gauges and the charge rate for weapons with charge attacks.\\nExtends the range in which ammo and arrows have maximum power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Focus/Stream Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Focus +3\\n\\nWater Attack +1",
    "decoration_description": "Increases the fill rate for weapons with gauges and the charge rate for weapons with charge attacks.\\nIncreases water element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Footing Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Tremor Resistance +1",
    "decoration_description": "Grants protection against ground tremors.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Foray Jewel 3",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Foray + 1",
    "decoration_description": "Increases attack power and affinity against large monsters affected by poison or paralysis.",
    "decoration_melding_cost": "Ancient Orb - Armor"
  },
  {
    "decoration_name": "Forceshot Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Normal Shots +1",
    "decoration_description": "Increases the attack power of Normal Ammo, normal arrows, and Flying Swallow Shot.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Friendship Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Wide/Range +1",
    "decoration_description": "Allows the effects of certain items to also affect nearby allies.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Frost Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Ice Attack +1",
    "decoration_description": "Increases ice element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Frost Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Ice Attack +2",
    "decoration_description": "Increases ice element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Frost Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Ice Attack +3",
    "decoration_description": "Increases ice element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Frost/Bandolier Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Ice Attack +3\\n\\nTetrad Shot +1",
    "decoration_description": "Increases ice element attack power. (Elemental attack power has a maximum limit.)\\nIncreases affinity of bowgun ammo/ coatings from the fourth shot and attack of the fourth and sixth shots.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Frost/Crit Elem Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Ice Attack + 3\\n\\nCritical Element + 1",
    "decoration_description": "Increases ice element attack power. (Elemental attack power has a maximum limit.)\\nIncreases elemental damage (fire, water, thunder, ice, dragon) when landing critical hits.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Frost/Enhancer Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Ice Attack + 3\\n\\nPower Prolonger + 1",
    "decoration_description": "Increases ice element attack power. (Elemental attack power has a maximum limit.)\\nAllows long swords, dual blades, insect glaives, switch axes, and charge blades to stay powered up longer.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Frost/Focus Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Ice Attack + 3\\n\\nFocus + 1",
    "decoration_description": "Increases ice element attack power. (Elemental attack power has a maximum limit.)\\nIncreases the fill rate for weapons with gauges and the charge rate for weapons with charge attacks.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Frost/Guardian Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Ice Attack + 3\\n\\nOffensive Guard + 1",
    "decoration_description": "Increases ice element attack power. (Elemental attack power has a maximum limit.)\\nTemporarily increases attack power after executing a perfectly/timed guard.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Frost/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Ice Attack + 3\\n\\nHandicraft + 1",
    "decoration_description": "Increases ice element attack power. (Elemental attack power has a maximum limit.)\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Frost/Ironwall Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Ice Attack + 3\\n\\nGuard +1",
    "decoration_description": "Increases ice element attack power. (Elemental attack power has a maximum limit.)\\nReduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Frost/KO Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Ice Attack + 3\\n\\nSlugger + 1",
    "decoration_description": "Increases ice element attack power. (Elemental attack power has a maximum limit.)\\nMakes it easier to stun monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Frost/Opener Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Ice Attack + 3\\n\\nOpening Shot + 1",
    "decoration_description": "Increases ice element attack power. (Elemental attack power has a maximum limit.)\\nIncreases the bowgun's reload speed and increases the power of bullets when fully loaded.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Frost/Precise Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Ice Attack + 3\\n\\nBallistics + 1",
    "decoration_description": "Increases ice element attack power. (Elemental attack power has a maximum limit.)\\nExtends the range in which ammo and arrows have maximum power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Frost/Quickswitch Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Ice Attack + 3\\n\\nRapid Morph + 1",
    "decoration_description": "Increases ice element attack power. (Elemental attack power has a maximum limit.)\\nIncreases switch speed and power for switch axes and charge blades.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Frost/Rzr Sharp Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Ice Attack + 3\\n\\nRazor Sharp + 1",
    "decoration_description": "Increases ice element attack power. (Elemental attack power has a maximum limit.)\\nPrevents your weapon from losing sharpness.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Frost/Shield Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Ice Attack + 3\\n\\nGuard Up + 1",
    "decoration_description": "Increases ice element attack power. (Elemental attack power has a maximum limit.)\\nAllows you to guard against ordinarily unblockable attacks.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Fungiform Jewel 2",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Mushroomancer +1",
    "decoration_description": "Lets you digest mushrooms that would otherwise be inedible and gain their advantageous effects.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Furor Jewel 2",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Resentment +1",
    "decoration_description": "Increases attack when you have recoverable damage (the red portion of your Health Gauge).",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Gambit Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Punishing Draw +1",
    "decoration_description": "Adds a stun effect to draw attacks and slightly increases attack power. (Not effective while riding.)",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Gambit Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Punishing Draw +2",
    "decoration_description": "Adds a stun effect to draw attacks and slightly increases attack power. (Not effective while riding.)",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Gambit Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Punishing Draw +3",
    "decoration_description": "Adds a stun effect to draw attacks and slightly increases attack power. (Not effective while riding.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Gambit/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Punishing Draw + 3\\n\\nHandicraft + 1",
    "decoration_description": "Adds a stun effect to draw attacks and slightly increases attack power. (Not effective while riding.)\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Gambit/Ironwall Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Punishing Draw +3\\n\\nGuard +1",
    "decoration_description": "Adds a stun effect to draw attacks and slightly increases attack power. (Not effective while riding.)\\nReduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Gambit/KO Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Punishing Draw + 3\\nSlugger + 1",
    "decoration_description": "Adds a stun effect to draw attacks and slightly increases attack power. (Not effective while riding.)\\nMakes it easier to stun monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Geology Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Geologist +1",
    "decoration_description": "Increases the number of items you gain at gathering points.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Gobbler Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Speed Eating +1",
    "decoration_description": "Increases meat/eating and item/consumption speed.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Grinder Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Speed Sharpening +1",
    "decoration_description": "Speeds up weapon sharpening when using a whetstone.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Grinder Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Speed Sharpening +2",
    "decoration_description": "Speeds up weapon sharpening when using a whetstone.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Grinder/Attack Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Speed Sharpening + 2\\nAttack Boost + 1",
    "decoration_description": "Speeds up weapon sharpening when using a whetstone.\\nIncreases attack power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Grinder/Draw Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Speed Sharpening + 2\\n\\nCritical Draw +1",
    "decoration_description": "Speeds up weapon sharpening when using a whetstone.\\nIncreases affinity when performing draw attacks. (Not effective while riding.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Grinder/Expert Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Speed Sharpening +2\\n\\nCritical Eye + 1",
    "decoration_description": "Speeds up weapon sharpening when using a whetstone.\\nIncreases affinity.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Grinder/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Speed Sharpening +2\\n\\nHandicraft + 1",
    "decoration_description": "Speeds up weapon sharpening when using a whetstone.\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Grinder/Ironwall Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Speed Sharpening + 2\\n\\nGuard + 1",
    "decoration_description": "Speeds up weapon sharpening when using a whetstone.\\nReduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Grinder/KO Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Speed Sharpening +2\\n\\nSlugger + 1",
    "decoration_description": "Speeds up weapon sharpening when using a whetstone.\\nMakes it easier to stun monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Growth Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Self/Improvement +1",
    "decoration_description": "Attack and defense increase as time passes while on a quest. (The maximum is reached after 30 minutes.)",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Guardian Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Offensive Guard +1",
    "decoration_description": "Temporarily increases attack power after executing a perfectly/timed guard.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Guardian Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Offensive Guard +2",
    "decoration_description": "Temporarily increases attack power after executing a perfectly/timed guard.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Guardian Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Offensive Guard + 3",
    "decoration_description": "Temporarily increases attack power after executing a perfectly/timed guard.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Guardian/Blaze Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Offensive Guard + 3\\n\\nFire Attack + 1",
    "decoration_description": "Temporarily increases attack power after executing a perfectly/timed guard.\\nIncreases fire element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Guardian/Bolt Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Offensive Guard + 3\\nThunder Attack + 1",
    "decoration_description": "Temporarily increases attack power after executing a perfectly/timed guard.\\nIncreases thunder element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Guardian/Dragon Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Offensive Guard + 3\\n\\nDragon Attack + 1",
    "decoration_description": "Temporarily increases attack power after executing a perfectly/timed guard.\\nIncreases dragon element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Guardian/Frost Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Offensive Guard + 3\\n\\nIce Attack + 1",
    "decoration_description": "Temporarily increases attack power after executing a perfectly/timed guard.\\nIncreases ice element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Guardian/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Offensive Guard + 3\\n\\nHandicraft + 1",
    "decoration_description": "Temporarily increases attack power after executing a perfectly/timed guard.\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Guardian/Ironwall Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Offensive Guard + 3\\n\\nGuard + 1",
    "decoration_description": "Temporarily increases attack power after executing a perfectly/timed guard.\\nReduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Guardian/Stream Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Offensive Guard + 3\\n\\nWater Attack + 1",
    "decoration_description": "Temporarily increases attack power after executing a perfectly/timed guard.\\nIncreases water element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Handicraft Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Handicraft +1",
    "decoration_description": "Extends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Handicraft Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Handicraft +2",
    "decoration_description": "Extends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Handicraft Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Handicraft +3",
    "decoration_description": "Extends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Hungerless Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Hunger Resistance +1",
    "decoration_description": "Reduces maximum stamina depletion over time.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Ice Res Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Ice Resistance +1",
    "decoration_description": "Increases ice resistance. Also improves defense at higher levels.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Intimidator Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Intimidator +1",
    "decoration_description": "Reduces the chance small monsters will attack after spotting you. (Has no effect on certain monsters.)",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Ironwall Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Guard +1",
    "decoration_description": "Reduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Ironwall Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Guard +2",
    "decoration_description": "Reduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Ironwall Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Guard +3",
    "decoration_description": "Reduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Jumping Jewel 2",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Evade Extender +2",
    "decoration_description": "Increases evade distance.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "KO Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Slugger +1",
    "decoration_description": "Makes it easier to stun monsters.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "KO Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Slugger +2",
    "decoration_description": "Makes it easier to stun monsters.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "KO Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Slugger +3",
    "decoration_description": "Makes it easier to stun monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Leap Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Jump Master +1",
    "decoration_description": "Prevents attacks from knocking you back during a jump.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Magazine Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Load Shells +1",
    "decoration_description": "Improves reloading, and increases the gunlance's shell capacity and charge blade's phial capacity.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Magazine Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Load Shells +2",
    "decoration_description": "Improves reloading, and increases the gunlance's shell capacity and charge blade's phial capacity.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Magazine/Attack Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Load Shells + 2\\n\\nAttack Boost + 1",
    "decoration_description": "Improves reloading, and increases the gunlance's shell capacity and charge blade's phial capacity.\\nIncreases attack power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Magazine/Draw Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Load Shells + 2\\n\\nCritical Draw + 1",
    "decoration_description": "Improves reloading, and increases the gunlance's shell capacity and charge blade's phial capacity.\\nIncreases affinity when performing draw attacks. (Not effective while riding.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Magazine/Expert Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Load Shells +2\\nCritical Eye + 1",
    "decoration_description": "Improves reloading, and increases the gunlance's shell capacity and charge blade's phial capacity.\\nIncreases affinity.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Magazine/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Load Shells + 2\\n\\nHandicraft + 1",
    "decoration_description": "Improves reloading, and increases the gunlance's shell capacity and charge blade's phial capacity.\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Magazine/Ironwall Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Load Shells + 2\\n\\nGuard + 1",
    "decoration_description": "Improves reloading, and increases the gunlance's shell capacity and charge blade's phial capacity.\\nReduces knockbacks and stamina depletion when guarding",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Maintenance Jewel 2",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Tool Specialist +1",
    "decoration_description": "Reduces the recharge time for specialized tools.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Mastery Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Master's Touch +1",
    "decoration_description": "Prevents your weapon from losing sharpness during critical hits.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Medicine Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Recovery Up +1",
    "decoration_description": "Increases the amount recovered when restoring health.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Mighty Jewel 2",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Maximum Might +1",
    "decoration_description": "Increases affinity if stamina is kept full for a period of time.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Mind's Eye Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Mind's Eye +1",
    "decoration_description": "Your attacks are deflected less and deal more damage to hard targets.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Mind's Eye Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Mind's Eye +2",
    "decoration_description": "Your attacks are deflected less and deal more damage to hard targets.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Mind's Eye Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Mind's Eye +3",
    "decoration_description": "Your attacks are deflected less and deal more damage to hard targets.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Mirewalker Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Aquatic/Oilsilt Mobility +1",
    "decoration_description": "Grants resistance against impairments to mobility while in water, oilsilt, or streams.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Opener Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Opening Shot +1",
    "decoration_description": "Increases the bowgun's reload speed and increases the power of bullets when fully loaded.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Opener Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Opening Shot +2",
    "decoration_description": "Increases the bowgun's reload speed and increases the power of bullets when fully loaded.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Opener Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Opening Shot +3",
    "decoration_description": "Increases the bowgun's reload speed and increases the power of bullets when fully loaded.",
    "decoration_melding_cost": "Glowing Orb - Sword\\n\\nAncient Orb - Sword"
  },
  {
    "decoration_name": "Opener/Blaze Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Opening Shot + 3\\n\\nFire Attack + 1",
    "decoration_description": "Increases the bowgun's reload speed and increases the power of bullets when fully loaded.\\nIncreases fire element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Opener/Bolt Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Opening Shot + 3\\n\\nThunder Attack + 1",
    "decoration_description": "Increases the bowgun's reload speed and increases the power of bullets when fully loaded.\\nIncreases thunder element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Opener/Dragon Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Opening Shot + 3\\n\\nDragon Attack + 1",
    "decoration_description": "Increases the bowgun's reload speed and increases the power of bullets when fully loaded.\\nIncreases dragon element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Opener/Frost Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Opening Shot + 3\\n\\nIce Attack + 1",
    "decoration_description": "Increases the bowgun's reload speed and increases the power of bullets when fully loaded.\\nIncreases ice element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Opener/Ironwall Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Opening Shot + 3\\n\\nGuard + 1",
    "decoration_description": "Increases the bowgun's reload speed and increases the power of bullets when fully loaded.\\nReduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Opener/Precise Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Opening Shot + 3\\n\\nBallistics + 1",
    "decoration_description": "Increases the bowgun's reload speed and increases the power of bullets when fully loaded.\\nExtends the range in which ammo and arrows have maximum power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Opener/Stream Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Opening Shot + 3\\n\\nWater Attack + 1",
    "decoration_description": "Increases the bowgun's reload speed and increases the power of bullets when fully loaded.\\nIncreases water element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Paracoat Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Para Functionality +1",
    "decoration_description": "Allows you to apply paralysis coatings.",
    "decoration_melding_cost": "Glowing Orb - Sword\\n\\nAncient Orb - Sword"
  },
  {
    "decoration_name": "Paralyzer Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Paralysis Attack +1",
    "decoration_description": "Increases the rate of paralysis buildup. (Paralysis buildup has a maximum limit.)",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Paralyzer Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Paralysis Attack +2",
    "decoration_description": "Increases the rate of paralysis buildup. (Paralysis buildup has a maximum limit.)",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Paralyzer Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Paralysis Attack +3",
    "decoration_description": "Increases the rate of paralysis buildup. (Paralysis buildup has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Pep Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Sleep Resistance +1",
    "decoration_description": "Reduces the duration of sleep.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Perfume Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Stench Resistance +1",
    "decoration_description": "Grants protection against stench.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Phoenix Jewel 2",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Coalescence +1",
    "decoration_description": "Temporarily increases elemental attack power and status effects after recovering from blights or abnormal status.",
    "decoration_melding_cost": "400 pts at the Melding Pot"
  },
  {
    "decoration_name": "Physique Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Constitution +1",
    "decoration_description": "Reduces stamina depletion when evading, blocking, or doing certain other actions.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Pierce Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Piercing Shots + 1",
    "decoration_description": "Increases the attack of the bowgun's Pierce Ammo, and the bow's Dragon Piercer and Thousand Dragons.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Poison Jewel 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Poison Duration Up +2",
    "decoration_description": "Extends the duration of your poison's effect on monsters.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Poison/Attack Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Poison Duration Up + 1\\n\\nAttack Boost + 1",
    "decoration_description": "Extends the duration of your poison's effect on monsters.\\nIncreases attack power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Poison/Draw Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Poison Duration Up + 1\\n\\nCritical Draw + 1",
    "decoration_description": "Extends the duration of your poison's effect on monsters.\\nIncreases affinity when performing draw attacks. (Not effective while riding.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Poison/Expert Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Poison Duration Up +1\\n\\nCritical Eye +1",
    "decoration_description": "Extends the duration of your poison's effect on monsters.\\nIncreases affinity.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Poison/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Poison Duration Up +1\\n\\nHandicraft + 1",
    "decoration_description": "Extends the duration of your poison's effect on monsters.\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Poison/Ironwall Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Poison Duration Up + 1\\n\\nGuard +1",
    "decoration_description": "Extends the duration of your poison's effect on monsters.\\nReduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Poison/KO Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Poison Duration Up +1\\n\\nSlugger +1",
    "decoration_description": "Extends the duration of your poison's effect on monsters.\\nMakes it easier to stun monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Poison/Precise Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Poison Duration Up + 1\\n\\nBallistics + 1",
    "decoration_description": "Extends the duration of your poison's effect on monsters.\\nExtends the range in which ammo and arrows have maximum power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Poisoncoat Jewel 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Poison Functionality +1",
    "decoration_description": "Allows you to apply poison coatings.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Potential Jewel 2",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Heroics +1",
    "decoration_description": "Increases attack power and defense when health drops to 35% or lower.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Precise Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Ballistics +1",
    "decoration_description": "Extends the range in which ammo and arrows have maximum power.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Precise Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Ballistics +2",
    "decoration_description": "Extends the range in which ammo and arrows have maximum power.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Precise Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Ballistics +3",
    "decoration_description": "Extends the range in which ammo and arrows have maximum power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Protection Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Divine Blessing +1",
    "decoration_description": "Has a predetermined chance of reducing the damage you take.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Quickswitch Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Rapid Morph +1",
    "decoration_description": "Increases switch speed and power for switch axes and charge blades.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Quickswitch Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Rapid Morph +2",
    "decoration_description": "Increases switch speed and power for switch axes and charge blades.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Quickswitch Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Rapid Morph +3",
    "decoration_description": "Increases switch speed and power for switch axes and charge blades.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Quickswitch/Blaze Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Rapid Morph + 3\\n\\nFire Attack + 1",
    "decoration_description": "Increases switch speed and power for switch axes and charge blades.\\nIncreases fire element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Quickswitch/Bolt Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Rapid Morph + 3\\n\\nThunder Attack + 1",
    "decoration_description": "Increases switch speed and power for switch axes and charge blades.\\nIncreases thunder element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Quickswitch/Dragon Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Rapid Morph + 3\\n\\nDragon Attack + 1",
    "decoration_description": "Increases switch speed and power for switch axes and charge blades.\\nIncreases dragon element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Quickswitch/Frost Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Rapid Morph + 3\\n\\nIce Attack + 1",
    "decoration_description": "Increases switch speed and power for switch axes and charge blades.\\nIncreases ice element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Quickswitch/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Rapid Morph + 3\\n\\nHandicraft + 1",
    "decoration_description": "Increases switch speed and power for switch axes and charge blades.\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Quickswitch/Ironwall Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Rapid Morph + 3\\n\\nGuard + 1",
    "decoration_description": "Increases switch speed and power for switch axes and charge blades.\\nReduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Quickswitch/KO Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Rapid Morph + 3\\n\\nSlugger + 1",
    "decoration_description": "Increases switch speed and power for switch axes and charge blades.\\nMakes it easier to stun monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Quickswitch/Stream Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Rapid Morph + 3\\n\\nWater Attack + 1",
    "decoration_description": "Increases switch speed and power for switch axes and charge blades.\\nIncreases water element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Ranger Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Outdoorsman +1",
    "decoration_description": "Improves fishing, grilling, and transporting abilities.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Razor Sharp Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Razor Sharp +1",
    "decoration_description": "Prevents your weapon from losing sharpness.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Razor Sharp Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Razor Sharp +2",
    "decoration_description": "Prevents your weapon from losing sharpness.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Razor Sharp/KO Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Razor Sharp + 3\\n\\nSlugger + 1",
    "decoration_description": "Prevents your weapon from losing sharpness.\\nMakes it easier to stun monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Recovery Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Recovery Speed +1",
    "decoration_description": "Speeds healing of recoverable damage (the red portion of the Health Gauge).",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Refresh Jewel 2",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Stamina Surge +1",
    "decoration_description": "Speeds up stamina recovery.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Rzr Sharp Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Razor Sharp +3",
    "decoration_description": "Prevents your weapon from losing sharpness.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Rzr Sharp/Blaze Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Razor Sharp + 3\\n\\nFire Attack + 1",
    "decoration_description": "Prevents your weapon from losing sharpness.\\nIncreases fire element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Rzr Sharp/Bolt Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Razor Sharp + 3\\n\\nThunder Attack + 1",
    "decoration_description": "Prevents your weapon from losing sharpness.\\nIncreases thunder element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Rzr Sharp/Dragon Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Razor Sharp + 3\\n\\nDragon Attack + 1",
    "decoration_description": "Prevents your weapon from losing sharpness.\\nIncreases dragon element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Rzr Sharp/Frost Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Razor Sharp + 3\\n\\nIce Attack + 1",
    "decoration_description": "Prevents your weapon from losing sharpness.\\nIncreases ice element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Rzr Sharp/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Razor Sharp + 3\\n\\nHandicraft + 1",
    "decoration_description": "Prevents your weapon from losing sharpness.\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Rzr Sharp/Ironwall Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Razor Sharp + 3\\n\\nGuard + 1",
    "decoration_description": "Prevents your weapon from losing sharpness.\\nReduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Rzr Sharp/Stream Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 7",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Razor Sharp +3\\n\\nWater Attack + 1",
    "decoration_description": "Prevents your weapon from losing sharpness.\\nIncreases water element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Sa+o Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Rapid Fire Up +1",
    "decoration_description": "Improves light bowgun rapid fire.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Sane Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Antivirus +1",
    "decoration_description": "Once infected, makes it easier to overcome the Frenzy and increases affinity if cured.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Satiated Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Free Meal +1",
    "decoration_description": "Gives you a predetermined chance of consuming a food or drink item for free.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Sharp Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Protective Polish +1",
    "decoration_description": "Weapon sharpness does not decrease for a set time after sharpening.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Sharp Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Protective Polish +2",
    "decoration_description": "Weapon sharpness does not decrease for a set time after sharpening.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Sharp Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Protective Polish +3",
    "decoration_description": "Weapon sharpness does not decrease for a set time after sharpening.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Sheath Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Quick Sheathe +1",
    "decoration_description": "Speeds up weapon sheathing.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Shield Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Guard Up +1",
    "decoration_description": "Allows you to guard against ordinarily unblockable attacks.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Shield Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Guard Up +2",
    "decoration_description": "Allows you to guard against ordinarily unblockable attacks.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Shield Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Guard Up +3",
    "decoration_description": "Allows you to guard against ordinarily unblockable attacks.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Shield/Blaze Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Guard Up + 3\\n\\nFire Attack + 1",
    "decoration_description": "Allows you to guard against ordinarily unblockable attacks.\\nIncreases fire element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Shield/Bolt Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Guard Up +3\\n\\nThunder Attack + 1",
    "decoration_description": "Allows you to guard against ordinarily unblockable attacks.\\nIncreases thunder element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Shield/Dragon Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Guard Up + 3\\n\\nDragon Attack + 1",
    "decoration_description": "Allows you to guard against ordinarily unblockable attacks.\\nIncreases dragon element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Shield/Frost Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Guard Up + 3\\n\\nIce Attack + 1",
    "decoration_description": "Allows you to guard against ordinarily unblockable attacks.\\nIncreases ice element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Shield/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Guard Up +3\\n\\nHandicraft + 1",
    "decoration_description": "Allows you to guard against ordinarily unblockable attacks.\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Shield/Ironwall Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Guard Up + 3\\n\\nGuard + 1",
    "decoration_description": "Allows you to guard against ordinarily unblockable attacks.\\nReduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Shield/Stream Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Guard Up + 3\\n\\nWater Attack + 1",
    "decoration_description": "Allows you to guard against ordinarily unblockable attacks.\\nIncreases water element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Shockproof Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Shock Absorber +1",
    "decoration_description": "Disables damage reactions when you hit a friend or when a friend hits you.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Sleep Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Sleep Attack +1",
    "decoration_description": "Increases the rate of sleep buildup. (Sleep buildup has a maximum limit.)",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Sleep Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Sleep Attack +2",
    "decoration_description": "Increases the rate of sleep buildup. (Sleep buildup has a maximum limit.)",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Sleep Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Sleep Attack +3",
    "decoration_description": "Increases the rate of sleep buildup. (Sleep buildup has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Sleepcoat Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Sleep Functionality + 1",
    "decoration_description": "Allows you to apply sleep coatings.",
    "decoration_melding_cost": "Glowing Orb - Sword\\n\\nAncient Orb - Sword"
  },
  {
    "decoration_name": "Sonorous Jewel 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Horn Maestro +1",
    "decoration_description": "Increases the effect duration of hunting horn melodies. (Effect lost when you change weapons.)",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Sonorous/Attack Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Horn Maestro +2\\n\\nAttack Boost +1",
    "decoration_description": "Increases the effect duration of hunting horn melodies. (Effect lost when you change weapons.)\\nIncreases attack power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Sonorous/Draw Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Horn Maestro +2\\n\\nCritical Draw +1",
    "decoration_description": "Increases the effect duration of hunting horn melodies. (Effect lost when you change weapons.)\\nIncreases affinity when performing draw attacks. (Not effective while riding.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Sonorous/Expert Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Horn Maestro +2\\n\\nCritical Eye +1",
    "decoration_description": "Increases the effect duration of hunting horn melodies. (Effect lost when you change weapons.)\\nIncreases affinity.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Sonorous/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Horn Maestro + 3\\n\\nHandicraft + 1",
    "decoration_description": "Increases the effect duration of hunting horn melodies. (Effect lost when you change weapons.)\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Sonorous/KO Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Horn Maestro + 3\\n\\nSlugger + 1",
    "decoration_description": "Increases the effect duration of hunting horn melodies. (Effect lost when you change weapons.)\\nMakes it easier to stun monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Specimen Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Entomologist +1",
    "decoration_description": "The bodies of small insect monsters won't be destroyed, allowing them to be carved.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Spread Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Spread/Power Shots + 1",
    "decoration_description": "Increases the attack of the bowgun's Spread Ammo and the bow's Power Shots and Quick Shots.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Sprinter Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Marathon Runner +1",
    "decoration_description": "Slows down stamina depletion for actions that continuously drain stamina (such as dashing).",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Steadfast Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Stun Resistance +1",
    "decoration_description": "Reduces the duration of stun.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Stream Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Water Attack +1",
    "decoration_description": "Increases water element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Stream Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Water Attack +2",
    "decoration_description": "Increases water element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Stream Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Water Attack +3",
    "decoration_description": "Increases water element attack power. (Elemental attack power has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Stream/Bandolier Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Water Attack + 3\\n\\nTetrad Shot + 1",
    "decoration_description": "Increases water element attack power. (Elemental attack power has a maximum limit.)\\nIncreases affinity of bowgun ammo/ coatings from the fourth shot and attack of the fourth and sixth shots.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Stream/Crit Elem Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Water Attack + 3\\n\\nCritical Element + 1",
    "decoration_description": "Increases water element attack power. (Elemental attack power has a maximum limit.)\\nIncreases elemental damage (fire, water, thunder, ice, dragon) when landing critical hits.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Stream/Enhancer Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Water Attack + 3\\n\\nPower Prolonger + 1",
    "decoration_description": "Increases water element attack power. (Elemental attack power has a maximum limit.)\\nAllows long swords, dual blades, insect glaives, switch axes, and charge blades to stay powered up longer.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Stream/Focus Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Water Attack + 3\\n\\nFocus + 1",
    "decoration_description": "Increases water element attack power. (Elemental attack power has a maximum limit.)\\nIncreases the fill rate for weapons with gauges and the charge rate for weapons with charge attacks.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Stream/Guardian Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Water Attack + 3\\n\\nOffensive Guard + 1",
    "decoration_description": "Increases water element attack power. (Elemental attack power has a maximum limit.)\\nTemporarily increases attack power after executing a perfectly/timed guard.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Stream/Handicraft Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Water Attack + 3\\n\\nHandicraft + 1",
    "decoration_description": "Increases water element attack power. (Elemental attack power has a maximum limit.)\\nExtends the weapon sharpness gauge. However, it will not increase the gauge past its maximum.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Stream/Ironwall Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Water Attack + 3\\n\\nGuard  + 1",
    "decoration_description": "Increases water element attack power. (Elemental attack power has a maximum limit.)\\nReduces knockbacks and stamina depletion when guarding.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Stream/KO Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Water Attack + 3\\n\\nSlugger + 1",
    "decoration_description": "Increases water element attack power. (Elemental attack power has a maximum limit.)\\nMakes it easier to stun monsters.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Stream/Opener Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Water Attack + 3\\n\\nOpening Shot + 1",
    "decoration_description": "Increases water element attack power. (Elemental attack power has a maximum limit.)\\nIncreases the bowgun's reload speed and increases the power of bullets when fully loaded.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Stream/Precise Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Water Attack + 3\\n\\nBallistics + 1",
    "decoration_description": "Increases water element attack power. (Elemental attack power has a maximum limit.)\\nExtends the range in which ammo and arrows have maximum power.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Stream/Quickswitch Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Water Attack + 3\\n\\nRapid Morph + 1",
    "decoration_description": "Increases water element attack power. (Elemental attack power has a maximum limit.)\\nIncreases switch speed and power for switch axes and charge blades.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Stream/Rzr Sharp Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Water Attack + 3\\n\\nRazor Sharp + 1",
    "decoration_description": "Increases water element attack power. (Elemental attack power has a maximum limit.)\\nPrevents your weapon from losing sharpness.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Stream/Shield Jewel 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 6",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Water Attack + 3\\n\\nGuard Up +1",
    "decoration_description": "Increases water element attack power. (Elemental attack power has a maximum limit.)\\nAllows you to guard against ordinarily unblockable attacks.",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Survival Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Survival Expert +1",
    "decoration_description": "Extra health is recovered from environmental interactables.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Suture Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Bleeding Resistance +1",
    "decoration_description": "Grants protection against bleeding.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Tenderizer Jewel 3",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Weakness Exploit + 1",
    "decoration_description": "Increases the affinity of attacks that exploit a monster's weak points and wounds.",
    "decoration_melding_cost": "Ancient Orb - Armor"
  },
  {
    "decoration_name": "Throttle Jewel 3",
    "decoration_type": "Armor  Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Latent Power + 1",
    "decoration_description": "Temporarily increases affinity and reduces stamina depletion when certain conditions are met.",
    "decoration_melding_cost": "Ancient Orb - Armor"
  },
  {
    "decoration_name": "Thunder Res Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Thunder Resistance +1",
    "decoration_description": "Increases thunder resistance. Also improves defense at higher levels.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Trueshot Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Special Ammo Boost +1",
    "decoration_description": "Increases the power of the bowgun's special ammo, and the bow's Dragon Piercer, Thousand Dragons, and Tracer.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Trueshot Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Special Ammo Boost +2",
    "decoration_description": "Increases the power of the bowgun's special ammo, and the bow's Dragon Piercer, Thousand Dragons, and Tracer.",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Venom Jewel 1",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Poison Attack +1",
    "decoration_description": "Increases the rate of poison buildup. (Poison buildup has a maximum limit.)",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Venom Jewel II 2",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 4",
    "decoration_slot": "Slot 2",
    "decoration_skill": "Poison Attack +2",
    "decoration_description": "Increases the rate of poison buildup. (Poison buildup has a maximum limit.)",
    "decoration_melding_cost": "80 pts at the Melding Pot"
  },
  {
    "decoration_name": "Venom Jewel III 3",
    "decoration_type": "Weapon Decoration",
    "decoration_rarity": "Rarity 5",
    "decoration_slot": "Slot 3",
    "decoration_skill": "Poison Attack +3",
    "decoration_description": "Increases the rate of poison buildup. (Poison buildup has a maximum limit.)",
    "decoration_melding_cost": "Ancient Orb - Sword"
  },
  {
    "decoration_name": "Water Res Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Water Resistance +1",
    "decoration_description": "Increases water resistance. Also improves defense at higher levels.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  },
  {
    "decoration_name": "Wind Resist Jewel 1",
    "decoration_type": "Armor Decoration",
    "decoration_rarity": "Rarity 3",
    "decoration_slot": "Slot 1",
    "decoration_skill": "Windproof +1",
    "decoration_description": "Grants protection against wind pressure.",
    "decoration_melding_cost": "20 pts at the Melding Pot"
  }
]


# Transformar los datos
formatted_json = json.dumps(transform_decorations(decorations), indent=4)

# Mostrar resultado
print(formatted_json)