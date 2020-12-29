local _, GW = ...

local T = {}

-- SL
--T[2422] = "SL/TheWildHunt"
--T[2439] = "SL/Avowed"
--T[2413] = "SL/CourtOfHarvesters"
--T[2410] = "SL/TheUndyingArmy"
--T[2407] = "SL/Ascended"
--T[2462] = "SL/Stitchmasters"
--T[2432] = "SL/Venari"
--T[2445] = "SL/TheEmverCourt"
--T[2459] = "SL/Sika"
--T[2452] = "SL/PolemarchAdrestes"
--T[2444] = "SL/TheWildHunt" -- Paragon
--T[2450] = "SL/AlecandrosMorgraine"
--T[2441] = "SL/Ascended" -- Paragon
--T[2456] = "SL/DromanAliothe"
--T[2447] = "SL/LadyMoonberry"
--T[2454] = "SL/Choofa"
--T[2453] = "SL/RendleAndCudgelface"
--T[2460] = "SL/Stonehead"
--T[2449] = "SL/Countess"
--T[2446] = "SL/BaronessVashj"
--T[2451] = "SL/HuntCaptainKorayn"
--T[2458] = "SL/KleiaAndPelagos"
--T[2448] = "SL/Mikanikos"
--T[2440] = "SL/TheUndyingArmy" -- Paragon
--T[2442] = "SL/CourtOfHarvesters" -- Paragon
--T[2455] = "SL/CryptkeeperKassir"
--T[2457] = "SL/GrandmasterVole"
--T[2461] = "SL/PlagueDeviserMarileth"

-- BFA
T[2159] = "BFA/7thLegion"
T[2164] = "BFA/Champions"
T[2161] = "BFA/AshesOrder"
T[2160] = "BFA/Proudmoore"
T[2162] = "BFA/Stormsong"
T[2163] = "BFA/Tortollans"
T[2156] = "BFA/Talanji Expe"
T[2158] = "BFA/Voldunai"
T[2103] = "BFA/Zandalari Empire"
T[2157] = "BFA/Honorbound"
T[2391] = "BFA/Meca"
T[2400] = "BFA/Ankoan"
T[2373] = "BFA/Unshackled"
T[2415] = "BFA/Rajani"
T[2417] = "BFA/Uldum Accord"
T[2395] = "BFA/Honeyback"

-- Legion
T[2170] = "Legion/Argus"
T[2135] = "Legion/Chromie"
T[2100] = "Legion/Corbyn"
T[1883] = "Legion/Dreamweaver"
T[1900] = "Legion/Farondis"
T[1828] = "Legion/HighMountain"
T[2097] = "Legion/Ilyssa"
T[2102] = "Legion/Impus"
T[2045] = "Legion/Legionfall"
T[2165] = "Legion/Light Army"
T[1975] = "Legion/Margoss"
T[2098] = "Legion/Raynae"
T[2099] = "Legion/Riverhorn"
T[1859] = "Legion/ShalDorei"
T[2101] = "Legion/Sha'leth"
T[2018] = "Legion/Talon"
T[1948] = "Legion/Valarjar"
T[1894] = "Legion/Wardens"

--WoD
T[1515] = "WOD/Arakkoa"
T[1849] = "WOD/Awakened"
T[1731] = "WOD/Exarchs"
T[1445] = "WOD/Frostwolf"
T[1848] = "WOD/Headhunters"
T[1708] = "WOD/Laughing Skull"
T[1847] = "WOD/Prophete's Hand"
T[1850] = "WOD/Saberstalkers"
T[1520] = "WOD/Shadowmoon Exiles"
T[1710] = "WOD/Sha'tari"
T[1681] = "WOD/Spear"
T[1732] = "WOD/Steamwheedle"
T[1711] = "WOD/Steamwheedle"
T[1735] = "WOD/Barracks Bodyguard"
T[1736] = "WOD/Tormmok"
T[1741] = "WOD/Leorajh"
T[1733] = "WOD/Delvar Ironfist"
T[1739] = "WOD/Vivianne"
T[1740] = "WOD/Aeda Brightdawn"
T[1737] = "WOD/Talonpriest Ishaal"
T[1738] = "WOD/Defender Illona"

--MoP
T[1351] = "MOP/Brewmasters"
T[1277] = "MOP/Chee Chee"
T[1440] = "MOP/Darkspear Rebellion"
T[1375] = "MOP/Dominance Offensive"
T[1275] = "MOP/Ella"
T[1283] = "MOP/Farmer Fung"
T[1282] = "MOP/Fish Fellreed"
T[1281] = "MOP/Gina Mudclaw"
T[1269] = "MOP/Golden Lotus"
T[1279] = "MOP/Haohan Mudclaw"
T[1228] = "MOP/Hozen"
T[1273] = "MOP/Jogu the Drunk"
T[1387] = "MOP/Kirin Tor Offensive"
T[1337] = "MOP/Klaxxis"
T[1345] = "MOP/Lorewalkers"
T[1358] = "MOP/Nat Pagle"
T[1276] = "MOP/Old Hillpaw"
T[1376] = "MOP/Operation Shieldwall"
T[1271] = "MOP/Order of the Cloud Serpent"
T[1242] = "MOP/Pearlfin Jinyu"
T[1435] = "MOP/Shado-Pan Assault"
T[1270] = "MOP/Shado-Pan"
T[1216] = "MOP/Shang Xi's Academy"
T[1492] = "MOP/Shaohao"
T[1278] = "MOP/Sho"
T[1388] = "MOP/Sunreaver Onslaught"
T[1302] = "MOP/The Anglers"
T[1341] = "MOP/The August Celestials"
T[1359] = "MOP/The Black Prince"
T[1272] = "MOP/The Tillers"
T[1280] = "MOP/Tina Mudclaw"

--Cata
T[1204] = "Cataclysm/Avengers of Hyjal"
T[1177] = "Cataclysm/Baradin"
T[1172] = "Cataclysm/Dragonmaw Clan"
T[1135] = "Cataclysm/Earthen Circle"
T[1158] = "Cataclysm/Guardians of Hyjal"
T[1178] = "Cataclysm/Hellscream's Reach"
T[1173] = "Cataclysm/Ramkahen"
T[1171] = "Cataclysm/Therazane"
T[1174] = "Cataclysm/Wildhammer"

--TLK
T[1037] = "TLK/Alliance Vanguard"
T[1106] = "TLK/Argent Crusade"
T[1098] = "TLK/Ebon Sword"
T[1068] = "TLK/Explorer's League"
T[1104] = "TLK/Frenzyheart Tribe"
T[1052] = "TLK/Horde expedition"
T[1090] = "TLK/Kirin'Tor"
T[1117] = "TLK/Sholazar Bassin"
T[1094] = "TLK/Silver Covenant"
T[1119] = "TLK/Sons of Hodir"
T[1156] = "TLK/The Ashen Verdict"
T[1067] = "TLK/The Hand of the Vengeance"
T[1073] = "TLK/The Kaluak"
T[1105] = "TLK/The Oracles"
T[1124] = "TLK/The Sunreavers"
T[1064] = "TLK/The Taunka"
T[1050] = "TLK/Valiance Expedition"
T[1085] = "TLK/Warsong Offensive"
T[1091] = "TLK/Wyrmrest"
T[1126] = "TLK/Frostborn"

--BC
T[930] = "BC/Exodar"
T[932] = "BC/Aldor"
T[1012] = "BC/Ashtongue"
T[942] = "BC/Cenarion Expe"
T[933] = "BC/Consortium"
T[946] = "BC/Honor Hold"
T[989] = "BC/Keepers of Time"
T[978] = "BC/Kurenai"
T[1011] = "BC/Lower city"
T[941] = "BC/Magar"
T[1015] = "BC/Netherwing"
T[1038] = "BC/Ogri'la"
T[990] = "BC/Scale of the Sands"
T[934] = "BC/Scryers"
T[1031] = "BC/Shatari Skyguard"
T[1077] = "BC/Shattered Sun Offensive"
T[936] = "BC/Shattrath City"
T[970] = "BC/Sporeggar"
T[935] = "BC/The Shatar"
T[967] = "BC/The Violet Eye"
T[947] = "BC/Thrallmar"
T[922] = "BC/Tranquillien"

--Classic & Other
T[891] = "Classic_Other/Alliance Forces"
T[469] = "Classic_Other/Alliance"
T[509] = "Classic_Other/Arathor's League"
T[529] = "Classic_Other/Argent Dawn"
T[1133] = "Classic_Other/Bilgewater"
T[1691] = "Classic_Other/Bizmo"
T[1419] = "Classic_Other/Bizmo"
T[2011] = "Classic_Other/Bizmo"
T[2371] = "Classic_Other/Bizmo"
T[87] = "Classic_Other/Bloodsail"
T[21] = "Classic_Other/BootyBay"
T[1374] = "Classic_Other/Brawl'gar Arena"
T[1690] = "Classic_Other/Brawl'gar Arena"
T[2010] = "Classic_Other/Brawl'gar Arena"
T[2372] = "Classic_Other/Brawl'gar Arena"
T[910] = "Classic_Other/Brood of Nozdormu"
T[609] = "Classic_Other/Cenarion Circle"
T[909] = "Classic_Other/Darkmoon"
T[530] = "Classic_Other/Darkspear"
T[69] = "Classic_Other/Darnassus"
T[577] = "Classic_Other/Everlook"
T[729] = "Classic_Other/Frostwolf"
T[369] = "Classic_Other/Gadgetzan"
T[92] = "Classic_Other/Gelkis Clan Centaur"
T[1134] = "Classic_Other/Gilneas"
T[54] = "Classic_Other/Gnomeregan"
T[1168] = "Classic_Other/Guild"
T[1169] = "Classic_Other/Guild"
T[892] = "Classic_Other/Horde Forces"
T[67] = "Classic_Other/Horde"
T[1352] = "Classic_Other/Huojin"
T[749] = "Classic_Other/Hydraxian"
T[47] = "Classic_Other/Ironforge"
T[93] = "Classic_Other/Magram Clan Centaur"
T[76] = "Classic_Other/Orgrimmar"
T[470] = "Classic_Other/Ratchet"
T[349] = "Classic_Other/Ravenholdt"
T[809] = "Classic_Other/Shen'dralar"
T[911] = "Classic_Other/Silvermoon"
T[890] = "Classic_Other/Silverwing"
T[169] = "Classic_Other/Steamwheedle Cartel"
T[730] = "Classic_Other/Stormpike"
T[72] = "Classic_Other/Stromwind"
T[70] = "Classic_Other/Syndicate"
T[510] = "Classic_Other/The Defliers"
T[59] = "Classic_Other/Thorium"
T[81] = "Classic_Other/Thunderbluf"
T[576] = "Classic_Other/Timbermaw"
T[1353] = "Classic_Other/Tushui"
T[68] = "Classic_Other/Undercity"
T[889] = "Classic_Other/Warsong"
T[589] = "Classic_Other/Wintersaber"
T[270] = "Classic_Other/Zandalar Tribes"

GW.REP_TEXTURES = T
