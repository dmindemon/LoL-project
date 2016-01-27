champions = read.csv('champions.csv')

get_info = function(data, name){
    condition = data[,2]==name
    info = data[condition,]
    info = info[,c(2,3,4,7,8,11,12,15,16,19)]
}

cal_level = function(data, level){
    move = data[,10]
    health = data[,2] + data[,3]*(level-1)
    mana = data[,4] + data[,5]*(level-1)
    magic = 0
    attack = data[,6] + data[,7]*(level-1)
    speed = data[,8] * (1 + data[,9]*(level-1))
    chance = 0
    data = data.frame(name=data[1], attack=attack, speed=speed, chance=chance, move=move, health=health, mana=mana, magic=magic)
}

return_info = function(data, champion, level){
    result = get_info(data, champion)
    base = cal_level(result, level)
    base
}

