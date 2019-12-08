AddCSLuaFile("cl_init.lua")

ENT.Base            = "bw_base_electronics"
ENT.PrintName       = "Cash Cab"

ENT.Model           = "models/props/de_nuke/nuclearcontainerboxclosed.mdl"
ENT.Color           = Color(0,0,0,255)
ENT.PowerCapacity   = 100000
ENT.Material        = "models/props/cs_assault/metal_stairs1"
ENT.MaxStorage      = 1500000
ENT.IsVault         = true
ENT.IsPrinter       = false

ENT.Sound =  "mvm/mvm_money_pickup.wav"
local UpgradeCost = {500000, 2500000, 12500000, 500000000, 0}

	function ENT:DerivedDataTables()
		self:NetworkVar("Float", 2, "Money")
		self:NetworkVar("Int", 3, "Upgrades")
		self:NetworkVar("Int", 4, "UpgradeCost")
	end

	function ENT:GetUsable()
		return true
	end
	
	function ENT:Init()
		self:SetRenderMode(RENDERMODE_TRANSALPHA)	
		self:SetMaterial(self.Material)
		self.Time=CurTime()
		self.Delay=5
		self.Radius=250
		self.MoneyStored=0
		self.CurrentValue=1
		self:SetUpgradeCost(UpgradeCost[1])
		self.UpgradeValue = 0
	end


	function ENT:ThinkFunc()
		local me = self:GetTable()
		if me.Time + me.Delay > CurTime() then return end
		if me.GetPower(self) < 500 then return end

		local owner = self:CPPIGetOwner()
		if owner:InRaid() and me.GetPower(self) < 5000 then me.Exhausted = true return end

		  
		me.Power = me.GetPower(me)
		me.Time=CurTime()
		local Upgrades=me.GetUpgrades(me)

		for k,v in pairs( ents.FindInSphere(self:GetPos(), me.Radius) ) do
			if not v.IsPrinter then continue end

			if v:CPPIGetOwner() == owner then 

				me.SetMoney(self, me.GetMoney(self) + v:GetMoney())

				if v.Money then v.Money = 0 end

				if Upgrades >= 1 then				
					v:AddPaper(5)
				end

			end

		 end



		if not owner:InRaid() then me.Exhausted = false end

		if Upgrades >= 2 then
			me.CurrentValue = (me.UpgradeValue or 0) + me:GetMoney() * 1.4
		end
	end--end thonk


	function ENT:TakeVaultDamage(dmg)
		if self:GetPower() < 1500 then self.Exhausted = true return end
		self:DrainPower(dmg * 20) 
	end



	function ENT:CollectMoney(ply)
		if self:GetMoney() <= 0 then return end

		hook.Run("BaseWars_PlayerEmptyPrinter", ply, self, self:GetMoney())

		ply:GiveMoney(self:GetMoney())
		self.CurrentValue = self.UpgradeValue
		self:SetMoney(0)
		ply:EmitSound(self.Sound or "")
	end
		
	function ENT:Use(act, call)
		if not act:IsPlayer() or not call:IsPlayer() then return end
		if self:CPPIGetOwner() ~= act then return end
		self:CollectMoney(act)
	end

	function ENT:Upgrade(ply)
		if not ply:IsPlayer() then return end
		if ply:GetMoney() < self:GetUpgradeCost() then ply:Notify(BaseWars.LANG.UpgradeNoMoney, BASEWARS_NOTIFICATION_ERROR) return end
		if self:GetUpgrades() + 1 > 4 then ply:Notify(BaseWars.LANG.UpgradeMaxLevel, BASEWARS_NOTIFICATION_ERROR) return end

			ply:TakeMoney(self:GetUpgradeCost())
			self.CurrentValue = (self.CurrentValue or 0) + self:GetUpgradeCost()
			self.UpgradeValue = self.UpgradeValue + self:GetUpgradeCost()
			self:SetUpgrades(self:GetUpgrades()+1)
			self:SetUpgradeCost(UpgradeCost[self:GetUpgrades()+1])

		if self:GetUpgrades() >= 3 then
			self.Radius=500
		end

	end

	function ENT:OnRemove()

		 for k,v in pairs(ents.FindInSphere(self:GetPos(), 1500)) do

			if v.IsPrinter then
				if v:CPPIGetOwner()==self:CPPIGetOwner() and v.SetDisabled then
					v:SetDisabled(false)
				end
			end

		 end

	end

	hook.Add("EntityTakeDamage", "NoDamageDisabled", function(ent, dmg)
		if not ent.IsPrinter then return end
		if not (ent.Disabled and ent.Vault) then return end

		local vault = ent.Vault
		if vault.Exhausted then return end

		vault:TakeVaultDamage(dmg:GetDamage())
		dmg:ScaleDamage(0)
		return true
	end)
