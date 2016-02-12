#ifndef _protagonist_H
#define _protagonist_H

#include "package.h"
#include "card.h"



class MofaCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE MofaCard();

    virtual void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};



class WuyuCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE WuyuCard();

    virtual void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
    virtual bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
};

class SaiqianCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE SaiqianCard();

    virtual bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
    virtual void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

class JiezouCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE JiezouCard();

    virtual void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
    virtual bool targetFilter(const QList<const Player *> &targets, const Player *to_select, const Player *Self) const;
};

class ShoucangCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE ShoucangCard();

    virtual void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

class BaoyiCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE BaoyiCard();

    virtual void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

class BllmSeyuCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE BllmSeyuCard();

    virtual void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &) const;
    virtual const Card *validate(CardUseStruct &cardUse) const;
};

class BllmShiyuDummy : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE BllmShiyuDummy();

    virtual void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &) const;
};

class BllmShiyuCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE BllmShiyuCard();

    virtual const Card *validate(CardUseStruct &cardUse) const;
    virtual const Card *validateInResponse(ServerPlayer *user) const;
};

class BllmWuyuCard : public SkillCard
{
    Q_OBJECT

public:
    Q_INVOKABLE BllmWuyuCard();

    virtual void use(Room *room, ServerPlayer *source, QList<ServerPlayer *> &targets) const;
};

class ProtagonistPackage : public Package
{
    Q_OBJECT

public:
    ProtagonistPackage();
};

#endif
