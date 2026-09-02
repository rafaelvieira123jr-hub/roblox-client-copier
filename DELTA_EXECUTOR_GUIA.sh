#!/bin/bash

# ============================================
# Script para Delta Executor - Roblox
# Executa o ClientCopier no Delta
# ============================================

echo "🎮 GUIA DE EXECUÇÃO NO DELTA EXECUTOR"
echo "======================================"
echo ""

# PASSO 1: Configurar ambiente
echo "📝 PASSO 1: Configuração Inicial"
echo "1. Abra o Delta Executor"
echo "2. Vá em: File > New Script"
echo "3. Copie todo o código abaixo"
echo ""

# PASSO 2: Código para o Delta
echo "📄 PASSO 2: Cole este código no Delta:"
echo ""
echo "======================================"
cat << 'EOF'

-- DELTA EXECUTOR - Copiar Cliente Roblox
local ClientCopier = {}

-- Copiar Modelos
function ClientCopier:copyModels()
    print("📦 Copiando modelos...")
    local models = {}
    for _, child in ipairs(workspace:GetDescendants()) do
        if child:IsA("BasePart") or child:IsA("Model") then
            table.insert(models, child:Clone())
        end
    end
    print("✅ " .. #models .. " modelos copiados!")
    return models
end

-- Copiar Scripts
function ClientCopier:copyScripts()
    print("📝 Copiando scripts...")
    local scripts = {}
    
    for _, child in ipairs(game.Players.LocalPlayer:GetDescendants()) do
        if child:IsA("LocalScript") or child:IsA("ModuleScript") then
            table.insert(scripts, {
                Name = child.Name,
                Source = child.Source
            })
        end
    end
    
    for _, child in ipairs(game.StarterPlayer:GetDescendants()) do
        if child:IsA("LocalScript") or child:IsA("ModuleScript") then
            table.insert(scripts, {
                Name = child.Name,
                Source = child.Source
            })
        end
    end
    
    print("✅ " .. #scripts .. " scripts copiados!")
    return scripts
end

-- Copiar GUI
function ClientCopier:copyGui()
    print("🎨 Copiando GUI...")
    local guis = {}
    
    for _, child in ipairs(game.Players.LocalPlayer:WaitForChild("PlayerGui"):GetDescendants()) do
        if child:IsA("GuiObject") then
            table.insert(guis, child:Clone())
        end
    end
    
    print("✅ " .. #guis .. " elementos GUI copiados!")
    return guis
end

-- Função Principal
function ClientCopier:copyAll()
    print("\n🎮 INICIANDO CÓPIA DE CLIENTE")
    print("=" .. string.rep("=", 40))
    
    local allData = {
        models = self:copyModels(),
        scripts = self:copyScripts(),
        guis = self:copyGui()
    }
    
    print("=" .. string.rep("=", 40))
    print("✅ CÓPIA CONCLUÍDA!")
    print("Total copiado:")
    print("  📦 Modelos: " .. #allData.models)
    print("  📝 Scripts: " .. #allData.scripts)
    print("  🎨 GUI: " .. #allData.guis)
    
    return allData
end

-- Restaurar Modelos
function ClientCopier:restoreModels(models, parent)
    print("\n🔄 Restaurando modelos...")
    parent = parent or workspace
    
    for _, model in ipairs(models) do
        local cloned = model:Clone()
        cloned.Parent = parent
    end
    
    print("✅ Modelos restaurados!")
end

-- Restaurar Scripts
function ClientCopier:restoreScripts(scripts, parent)
    print("🔄 Restaurando scripts...")
    parent = parent or game.ServerScriptService
    
    for _, scriptData in ipairs(scripts) do
        local newScript = Instance.new("LocalScript")
        newScript.Name = scriptData.Name
        newScript.Source = scriptData.Source
        newScript.Parent = parent
    end
    
    print("✅ Scripts restaurados!")
end

-- EXECUTAR
print("\n🚀 Iniciando ClientCopier no Delta Executor...")
local backup = ClientCopier:copyAll()

-- Opcional: Restaurar automaticamente
-- ClientCopier:restoreModels(backup.models)
-- ClientCopier:restoreScripts(backup.scripts)

print("\n✅ Script finalizado! Verifique o console acima.")

EOF
echo "======================================"
echo ""

# PASSO 3: Instruções de execução
echo "📋 PASSO 3: Executar no Delta"
echo "1. Cole o código acima no Delta Executor"
echo "2. Clique em 'Execute' ou pressione a tecla de execução"
echo "3. Aguarde o console mostrar ✅ CÓPIA CONCLUÍDA"
echo ""

# PASSO 4: O que fazer depois
echo "🎮 PASSO 4: Depois da Cópia"
echo ""
echo "OPÇÃO A: Salvar localmente"
echo "  → Use o console do Delta para copiar os dados"
echo "  → Cole em um arquivo .txt"
echo ""
echo "OPÇÃO B: Transferir para novo jogo"
echo "echo "  → Descomente as linhas de restauração no código"
echo "  → Execute em um novo jogo Roblox"
echo ""
echo "OPÇÃO C: Automatizar a restauração"
echo "  → Crie um segundo script que restaura os dados"
echo "  → Execute após a primeira cópia"
echo ""

echo "======================================"
echo "❓ DÚVIDAS?"
echo "======================================"
echo ""
echo "P: O Delta Executor funcionará?"
echo "R: Sim! O Delta é um executor de scripts Lua para Roblox"
echo ""
echo "P: Vai copiar TUDO?"
echo "R: Sim, modelos, scripts, GUI e estrutura do cliente"
echo ""
echo "P: Como transferir para outro jogo?"
echo "R: Descomente as funções de restauração no código"
echo ""
echo "P: É seguro?"
echo "R: Funciona apenas no seu próprio computador/conta"
echo ""
