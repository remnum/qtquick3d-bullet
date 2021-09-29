#include "bodypowersystem.h"

BodyPowerSystem::BodyPowerSystem()
{

}

void BodyPowerSystem::setMaxPower(int p)
{
    _max_power = p;
}

int BodyPowerSystem::maxPower()
{
    return _max_power;
}

void BodyPowerSystem::setDamagePower(int p)
{
    _damage_power = p;
}

int BodyPowerSystem::damagePower()
{
    return _damage_power;
}

void BodyPowerSystem::setCurrentPower(int p)
{
    _current_power = p;
}

int BodyPowerSystem::currentPower()
{
    return _current_power;
}
