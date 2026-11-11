---@diagnostic disable: undefined-global

-- Hilfsfunktionen für die Datenphase: Technologie-Effekte verschieben und
-- Verweise auf eine versteckte Technologie auf eine andere umbiegen.
local tech_util = {}

local function same_effect(a, b)
    if a.type ~= b.type then return false end
    if a.type == "unlock-recipe" then return a.recipe == b.recipe end
    -- Alle anderen Effekte (Modifier, give-item …) vollständig vergleichen
    return serpent.line(a) == serpent.line(b)
end

--- Fügt einen Effekt hinzu, falls es ihn in der Technologie noch nicht gibt.
function tech_util.add_effect(tech, effect)
    tech.effects = tech.effects or {}
    for _, existing in pairs(tech.effects) do
        if same_effect(existing, effect) then return end
    end
    if effect.type == "unlock-recipe" and not data.raw.recipe[effect.recipe] then return end
    table.insert(tech.effects, table.deepcopy(effect))
end

--- Verschiebt alle Effekte von `from_name` nach `to_name` und versteckt `from_name`.
--- Gibt true zurück, wenn beide Technologien existieren.
function tech_util.merge_into(from_name, to_name)
    local from = data.raw.technology[from_name]
    local to = data.raw.technology[to_name]
    if not (from and to) then return false end
    for _, effect in pairs(from.effects or {}) do
        tech_util.add_effect(to, effect)
    end
    from.effects = {}
    from.enabled = false
    from.hidden = true
    return true
end

--- Ersetzt `old_name` in den Voraussetzungen aller Technologien durch `new_name`
--- (ohne Duplikate und ohne Selbstverweis).
function tech_util.replace_prerequisite(old_name, new_name)
    for name, tech in pairs(data.raw.technology) do
        local prereqs = tech.prerequisites
        if prereqs and name ~= old_name then
            local result, seen, changed = {}, {}, false
            for _, prereq in ipairs(prereqs) do
                local target = prereq
                if prereq == old_name then
                    target = new_name
                    changed = true
                end
                if target ~= name and not seen[target] then
                    seen[target] = true
                    table.insert(result, target)
                end
            end
            if changed then tech.prerequisites = result end
        end
    end
end

-- Läuft rekursiv durch einen Tipps-&-Tricks-Trigger und biegt research-Trigger um.
local function retarget_trigger(trigger, old_name, new_name)
    if type(trigger) ~= "table" then return end
    if trigger.type == "research" and trigger.technology == old_name then
        trigger.technology = new_name
    end
    for _, value in pairs(trigger) do
        if type(value) == "table" then retarget_trigger(value, old_name, new_name) end
    end
end

--- Biegt alle Verweise auf `old_name` außerhalb des Technologiebaums um:
--- Shortcuts (technology_to_unlock) und Tipps & Tricks (research-Trigger).
function tech_util.retarget_references(old_name, new_name)
    for _, shortcut in pairs(data.raw.shortcut or {}) do
        if shortcut.technology_to_unlock == old_name then
            shortcut.technology_to_unlock = new_name
        end
    end
    for _, tip in pairs(data.raw["tips-and-tricks-item"] or {}) do
        retarget_trigger(tip.trigger, old_name, new_name)
        retarget_trigger(tip.skip_trigger, old_name, new_name)
    end
end

--- Versteckt `old_name` vollständig zugunsten von `new_name`.
function tech_util.replace_technology(old_name, new_name)
    if not tech_util.merge_into(old_name, new_name) then return end
    tech_util.replace_prerequisite(old_name, new_name)
    tech_util.retarget_references(old_name, new_name)
end

return tech_util
