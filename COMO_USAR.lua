--[[
    GUIA DE USO - ClientCopier
    Como usar o script para copiar conteúdo do cliente Roblox
]]--

local ClientCopier = require(script.Parent:WaitForChild("ClientCopier"))

-- ============================================
-- MÉTODO 1: Copiar TUDO de uma vez
-- ============================================
print("\n📋 MÉTODO 1: Copiar Tudo\n")

local clientData = ClientCopier:copyAll()

-- Exportar para JSON
local jsonExport = ClientCopier:exportToJson(clientData)
print("📦 Dados exportados em JSON")

-- ============================================
-- MÉTODO 2: Copiar apenas MODELOS
-- ============================================
print("\n📋 MÉTODO 2: Copiar apenas Modelos\n")

local models = ClientCopier:copyModels(workspace)
print("✅ Modelos copiados: " .. #models)

-- ============================================
-- MÉTODO 3: Copiar apenas SCRIPTS
-- ============================================
print("\n📋 MÉTODO 3: Copiar apenas Scripts\n")

local scripts = ClientCopier:copyScripts(game.Players.LocalPlayer)
print("✅ Scripts copiados: " .. #scripts)

-- ============================================
-- MÉTODO 4: Copiar apenas GUI
-- ============================================
print("\n📋 MÉTODO 4: Copiar apenas GUI\n")

local gui = ClientCopier:copyGui(game.Players.LocalPlayer:WaitForChild("PlayerGui"))
print("✅ GUI copiada: " .. #gui)

-- ============================================
-- MÉTODO 5: Restaurar MODELOS em novo jogo
-- ============================================
print("\n📋 MÉTODO 5: Restaurar Modelos\n")

-- Cria uma pasta para os modelos restaurados
local backupFolder = Instance.new("Folder")
backupFolder.Name = "ModelsRestored"
backupFolder.Parent = workspace

ClientCopier:restoreModels(models, backupFolder)

-- ============================================
-- MÉTODO 6: Restaurar SCRIPTS em novo jogo
-- ============================================
print("\n📋 MÉTODO 6: Restaurar Scripts\n")

-- Cria uma pasta para os scripts restaurados
local scriptsFolder = Instance.new("Folder")
scriptsFolder.Name = "ScriptsRestored"
scriptsFolder.Parent = game.ServerScriptService

ClientCopier:restoreScripts(scripts, scriptsFolder)

-- ============================================
-- EXEMPLO COMPLETO: Cópia + Restauração
-- ============================================
print("\n📋 EXEMPLO COMPLETO: Copiar e Restaurar\n")

-- PASSO 1: Copiar tudo
local fullBackup = ClientCopier:copyAll()

-- PASSO 2: Salvar (em Studio)
local jsonData = ClientCopier:exportToJson(fullBackup)

-- PASSO 3: Criar estrutura no novo jogo
local backupRoot = Instance.new("Folder")
backupRoot.Name = "ClientBackup_" .. os.date("%Y%m%d_%H%M%S")
backupRoot.Parent = workspace

-- PASSO 4: Restaurar modelos
if fullBackup.copyData.models then
    local modelFolder = Instance.new("Folder")
    modelFolder.Name = "Models"
    modelFolder.Parent = backupRoot
    ClientCopier:restoreModels(fullBackup.copyData.models, modelFolder)
end

-- PASSO 5: Restaurar scripts
if fullBackup.copyData.scripts then
    local scriptFolder = Instance.new("Folder")
    scriptFolder.Name = "Scripts"
    scriptFolder.Parent = backupRoot
    ClientCopier:restoreScripts(fullBackup.copyData.scripts, scriptFolder)
end

print("✅ Cópia completa e restauração finalizada!")
print("📁 Tudo foi restaurado em: " .. backupRoot:GetFullName())
