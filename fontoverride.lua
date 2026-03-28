-- Nadpisanie czcionek na ramkach questów WoW na wersje z polskimi znakami
-- Brak warunku locale - zawsze ładuje polskie fonty

local PL_Font1 = "Interface\\AddOns\\pfQuest\\Fonts\\morpheus_pl.ttf"
local PL_Font2 = "Interface\\AddOns\\pfQuest\\Fonts\\frizquadratatt_pl.ttf"

local function SafeSetFont(frame, font, size, flags)
  if frame and frame.SetFont then
    frame:SetFont(font, size, flags)
    return true
  end
  return false
end

local function ApplyQuestLogFonts()
  local ok = true

  ok = SafeSetFont(QuestLogQuestTitle,       PL_Font2, 17) and ok
  ok = SafeSetFont(QuestLogObjectivesText,   PL_Font2, 14) and ok
  ok = SafeSetFont(QuestLogQuestDescription, PL_Font2, 14) and ok
  ok = SafeSetFont(QuestLogDescriptionTitle, PL_Font2, 14) and ok
  ok = SafeSetFont(QuestLogItemChooseText,   PL_Font2, 12) and ok
  ok = SafeSetFont(QuestLogItemReceiveText,  PL_Font2, 12) and ok
  ok = SafeSetFont(QuestLogSpellLearnText,   PL_Font2, 12) and ok
  ok = SafeSetFont(QuestLogPlayerTitleText,  PL_Font2, 12) and ok
  ok = SafeSetFont(QuestLogRewardTitleText,  PL_Font2, 14) and ok
  ok = SafeSetFont(QuestLogNoQuests,         PL_Font2, 14) and ok
  ok = SafeSetFont(QuestLogQuestsTitle,      PL_Font1, 18) and ok

  return ok
end

local f = CreateFrame("Frame")
local elapsedTotal = 0
local retries = 0
local maxRetries = 20

f:RegisterEvent("PLAYER_LOGIN")

f:SetScript("OnEvent", function()
  ApplyQuestLogFonts()

  -- Jeśli QuestLogFrame już istnieje, dołóż fonty przy każdym pokazaniu okna
  if QuestLogFrame then
    if QuestLogFrame.HookScript then
      QuestLogFrame:HookScript("OnShow", ApplyQuestLogFonts)
    else
      local oldOnShow = QuestLogFrame:GetScript("OnShow")
      QuestLogFrame:SetScript("OnShow", function()
        if oldOnShow then oldOnShow() end
        ApplyQuestLogFonts()
      end)
    end
    return
  end

  -- Fallback: przez chwilę próbuj, aż QuestLogFrame się pojawi
  f:SetScript("OnUpdate", function()
    elapsedTotal = elapsedTotal + arg1
    if elapsedTotal < 0.5 then return end
    elapsedTotal = 0

    retries = retries + 1

    if ApplyQuestLogFonts() then
      if QuestLogFrame then
        if QuestLogFrame.HookScript then
          QuestLogFrame:HookScript("OnShow", ApplyQuestLogFonts)
        else
          local oldOnShow = QuestLogFrame:GetScript("OnShow")
          QuestLogFrame:SetScript("OnShow", function()
            if oldOnShow then oldOnShow() end
            ApplyQuestLogFonts()
          end)
        end
      end
      f:SetScript("OnUpdate", nil)
      return
    end

    if retries >= maxRetries then
      f:SetScript("OnUpdate", nil)
    end
  end)
end)