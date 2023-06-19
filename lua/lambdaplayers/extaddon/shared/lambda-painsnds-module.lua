LambdaRegisterVoiceType( "pain", "lambdaplayers/vo/pain", "These are voice lines that play when a Lambda Player is damaged." )

local random = math.random
local rand = math.Rand
local CurTime = CurTime

local painsndsEnabled  = CreateLambdaConvar( "lambdaplayers_voice_painsnds_enable", 1, true, false, false, "Enables pain sounds to be played by Lambdas.", 0, 1, { name = "Enable Pain Sounds", type = "Bool", category = "Voice Options" } )
local painsndsInterrupt  = CreateLambdaConvar( "lambdaplayers_voice_painsnds_interrupt", 0, true, false, false, "Should pain sounds play while speaking?.", 0, 1, { name = "Enable voice interruption", type = "Bool", category = "Voice Options" } )

--if ( CLIENT ) then return end

local function Initialize( self )
	-- Init delay sound timer
	self.l_randompainline = 0

	hook.Add( "LambdaOnInjured", "LambdaPainVoice_OnInjuried", function( self, dmginfo )
		if !painsndsEnabled:GetBool() then return end
	
		local attacker = dmginfo:GetAttacker()
		if attacker == self then return end
	
		if CurTime() > self.l_randompainline then

			if random( 1, 100 ) <= self:GetVoiceChance() and !self:IsSpeaking() then
				self:PlaySoundFile( self:GetVoiceLine( "pain" ) )
			elseif random( 1, 100 ) <= self:GetVoiceChance() and painsndsInterrupt:GetBool() then
				self:PlaySoundFile( self:GetVoiceLine( "pain" ) )
			end
			
			-- set delay to avoid spam
			if !painsndsInterrupt:GetBool() then
				self.l_randompainline = CurTime() + rand( 0.8, 1.6 )
			else
				self.l_randompainline = CurTime() + rand( 1.1, 2.5 )
			end
			
			--for _,v in ipairs(player.GetAll()) do
			--	v:ChatPrint("Pain Sound Played.")
			--end
		end
	end)
end

hook.Add( "LambdaOnInitialize", "lambdapainsnds_init", Initialize )