LambdaRegisterVoiceType( "pain", "lambdaplayers/vo/pain", "These are voice lines that play when a Lambda Player is damaged." )

local random = math.random
local rand = math.Rand
local CurTime = CurTime
local ceil = math.ceil

local painsndsEnabled  = CreateLambdaConvar( "lambdaplayers_voice_painsnds_enable", 1, true, false, false, "Enables pain sounds to be played by Lambdas.", 0, 1, { name = "Enable Pain Sounds", type = "Bool", category = "Voice Options" } )
local painsndsInterrupt  = CreateLambdaConvar( "lambdaplayers_voice_painsnds_interrupt", 0, true, false, false, "Should pain sounds play while speaking?.", 0, 1, { name = "Enable Pain Sounds", type = "Bool", category = "Voice Options" } )

if ( CLIENT ) then return end

local function Initialize( self )
    self.l_randompainline = 0

    hook.Add( "LambdaOnInjured", "LambdaPainVoice_OnInjuried", function( self, dmginfo )
        -- Do not play if convar is not set to 1
        if !painsndsEnabled:GetBool() then return end
    
        local attacker = dmginfo:GetAttacker()
        if attacker == self then return end
    
        -- Play random pain sound
        if CurTime() > self.l_randompainline then

            if random( 1, 75 ) <= self:GetVoiceChance() and !self:IsSpeaking() or painsndsInterrupt:GetBool() then
                self:PlaySoundFile( self:GetVoiceLine( "pain" ) )
            end

            self.l_randompainline = CurTime() + rand( 0.8, 1.6 ) -- Small delay to not spam
        end
    end)
end

hook.Add( "LambdaOnInitialize", "lambdapainsnds_init", Initialize )