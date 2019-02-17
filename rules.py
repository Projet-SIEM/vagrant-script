#!/usr/bin/env python3
import argparse

# echappement ^ $ \ | { } [ ] ( ) ? # ! + * .

espace = "\s"

def date(annee,mois,jour,heure,minutes,secondes):
    return "\["+annee.replace("X","[0-9]")+"-"+mois.replace("X","[0-9]")+"-"+jour.replace("X","[0-9]")+espace+heure.replace("X","[0-9]")+":"+minutes.replace("X","[0-9]")+":"+secondes.replace("X","[0-9]")+"\]"

def protocol(nom):
    return nom.replace("X",".*")

def addresse_ip(solt1,solt2,solt3,solt4):
    return solt1.replace("X","[0-9]")+"\."+solt2.replace("X","[0-9]")+"\."+solt3.replace("X","[0-9]")+"\."+solt4.replace("X","[0-9]")

def port(p):
    return p.replace("X","[0-9]")

def message(m):
    return m + "\\b"

def main():
    parser = argparse.ArgumentParser()
    groupMessage = parser.add_mutually_exclusive_group()
    parser.add_argument('--annee','-an',dest="annee",action='store',default="[0-9]{4}", help="annee ciblee")
    parser.add_argument('--mois','-mo',dest="mois",action='store', default="[0-9]{2}", help="mois cible")
    parser.add_argument('--jour','-jo',dest="jour",action='store', default="[0-9]{2}", help="jour cible")
    parser.add_argument('--heure','-he',dest="heure",action='store', default="[0-9]{2}", help="heure ciblee")
    parser.add_argument('--minutes','-mi',dest="minutes",action='store', default="[0-9]{2}", help="minutes ciblee")
    parser.add_argument('--secondes','-se',dest="secondes",action='store', default="[0-9]{2}", help="secondes ciblee")

    parser.add_argument('--protocolCouche3','-pc3',dest="protocolCouche3", default="\S+",action='store', help="protocol de la couche 3 a cibler")
    parser.add_argument('--protocolCouche4','-pc4',dest="protocolCouche4", default="\S+", action='store', help="protocol de la couche 4 a cibler")

    parser.add_argument('--addrIPSource','-ipS',dest="IPSource",action='store', default="[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}", help="IP source a cibler")
    parser.add_argument('--addrIPDestination','-ipD',dest="IPDest",action='store', default="[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}", help="IP destination a cibler")

    parser.add_argument('--portSource','-pS',dest="portSource",action='store', default="[0-9]{1,5}", help="port source a cibler")
    parser.add_argument('--portDestination','-pD',dest="portDest",action='store', default="[0-9]{1,5}", help="port destination a cibler")

    groupMessage.add_argument('--messagefull','-mf',dest="messf",action='store', help="Le message a cibler")
    groupMessage.add_argument('--message','-m',dest="mess",action='store', help="Partie du message a cibler")

    args = parser.parse_args()

    # parse les ip
    tabIPS = args.IPSource.split('.')
    tabIPD = args.IPDest.split('.')

    msg = ".*"

    if args.mess is not None :
        msg = (".*"+args.mess+".*").replace("X",".*")

    if args.messf is not None :
        msg = args.messf

    rule = date(args.annee,args.mois,args.jour,args.heure,args.minutes,args.secondes)+ espace+"+"\
    +protocol(args.protocolCouche3)+ espace+"+"+protocol(args.protocolCouche4)+ espace+"+"\
    +addresse_ip(tabIPS[0],tabIPS[1],tabIPS[2],tabIPS[3])+ espace+"+"\
    +addresse_ip(tabIPD[0],tabIPD[1],tabIPD[2],tabIPD[3])+ espace+"+"\
    +port(args.portSource)+ espace+"+"+port(args.portDest)+ espace+"+"\
    +message(msg)
    f = open('rules.txt','w')
    f.close()
    with open("rules.txt", "r+") as f:
        lignes = f.readlines()
        for ligne in lignes:
            if ligne == rule :
                print("Regle deja presente")
                exit(0)
        f.write(rule)
        print("Nouvelle regles ecrite:")
        print(rule)


if __name__ == "__main__" :
    main()
#
