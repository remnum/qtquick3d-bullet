#ifndef BODYPOWERSYSTEM_H
#define BODYPOWERSYSTEM_H


class BodyPowerSystem
{
public:
    BodyPowerSystem();

    void setMaxPower(int);
    int maxPower();

    void setDamagePower(int);
    int damagePower();

    void setCurrentPower(int);
    int currentPower();

private:
    int _max_power;
    int _damage_power;
    int _current_power;
};

#endif // BODYPOWERSYSTEM_H
