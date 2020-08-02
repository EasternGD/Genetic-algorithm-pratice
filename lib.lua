
-- 10進制轉2進制  字串型式
function toBinary(num)
    i = 0
    repeat
        remainder = num % 2
        if i == 0 then
            num2 = tostring(remainder)
        elseif remainder < 2 and i ~= 0 then
            num2 = num2 .. tostring(remainder)
        end
        num = math.floor(num / 2)
        i = i + 1
    until (num < 2)
    num2 = string.reverse(num2 .. "1")
    print("num2 = " .. num2)
    return num2
end


variable = {
    lowerBound = 0,
    upperBound = 0,
    precision = 0
}

function variable:new(obj, lowerBound, upperBound, precision)
    local obj = obj or {}
    setmetatable(obj, self)
    self.__index = self

    obj.lowerBound = lowerBound or 0
    obj.upperBound = upperBound or 0
    obj.precision = precision or 0

    return obj
end

--===================================染色體class====================================
--染色體類別
Chromosomes = {
    generation = 0,
    x_length = 0,
    y_length = 0,
    x_binaryValue = "",
    y_binaryValue = "",
    x_number = 0,
    y_number = 0,
    fitnessValue = 0,
    probability = 0,
    cumulativeProbability = 0,
    fxy = 0
}

--建構子
function Chromosomes:new(generation, x_binaryValue, y_binaryValue)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.generation = generation or nil
    obj.x_length = Chromosomes:getLength(x)
    obj.y_length = Chromosomes:getLength(y)
    obj.x_binaryValue = x_binaryValue or ""
    obj.y_binaryValue = y_binaryValue or ""
    obj.x_number = 0
    obj.y_number = 0
    return obj
end

function Chromosomes:getLength(var_class)
    local length = 0
    repeat
        length = length + 1
    until (var_class.upperBound - var_class.lowerBound) / (2 ^ length - 1) < 10 ^ (-var_class.precision)
    return length
end

--****************************適存值******************************
function Chromosomes:setFitnessValue(this)
    -- 逞罰值參數
    local C = 0.8
    local t = this.generation
    -- 逞罰函式
    local penaltyvalue = (C * t) ^ (1 / 2) * math.abs(this.x_number + this.y_number - 2) ^ (1 / 2)
    -- 染色體對應的函式值 f ( x , y )
    this.fxy = math.sin(5 * math.pi * (this.x_number ^ (3 / 4) - 0.1)) ^ 6 - (this.y_number - 1) ^ 4

    -- 如果超出限制區間
    if this.x_number + this.y_number < 2 then
        -- 加上逞罰值
        this.fitnessValue = this.fxy - penaltyvalue
    else
        this.fitnessValue = this.fxy
    end
end

-- 內插法賦值，取得染色體對應目標函式的 x , y 值
function Chromosomes:setNumber(this)
    -- 染色體長度
    genLength = {}
    genx_length = this.x_length
    geny_length = this.y_length
    -- 染色體二元值對應的十進位值
    decimalNum = {}
    decimalNum[x] = tonumber(this.x_binaryValue, 2)
    decimalNum[y] = tonumber(this.y_binaryValue, 2)
    -- 定義域大小
    domainLength = {}
    domainx_length = x.upperBound - x.lowerBound
    domainy_length = y.upperBound - y.lowerBound
    -- 位元數
    bits = {}
    bits[x] = 2 ^ genx_length
    bits[y] = 2 ^ geny_length
    -- 賦值
    this.x_number = x.lowerBound + decimalNum[x] * domainx_length / (bits[x] - 1)
    this.y_number = y.lowerBound + decimalNum[y] * domainy_length / (bits[y] - 1)
end

-- 選中機率賦值
function Chromosomes:setProbability(this)
    -- 找出最小值
    local minOne = 0
    for j = 1, #this do
        if j == 1 then
            -- 如果比第一條小
            -- 第一條必定最小
            minOne = this[j].fitnessValue
        elseif this[j].fitnessValue < minOne then
            -- 換人當
            minOne = this[j].fitnessValue
        end
    end

    -- 適存值總合
    local fitnessSum = 0
    --全加一遍
    for j, _ in ipairs(this) do
        fitnessSum = fitnessSum + (this[j].fitnessValue + math.abs(minOne))
    end
    --計算機率
    for j, _ in ipairs(this) do
        --加上最小值的絕對值，以防出現負機率
        this[j].probability = (this[j].fitnessValue + math.abs(minOne)) / fitnessSum
        if j ~= 1 then
            this[j].cumulativeProbability = this[j - 1].cumulativeProbability + this[j].probability
        else
            this[j].cumulativeProbability = this[j].probability
        end
    end
end

--****************************初始化******************************
function Chromosomes:initialization(size)
    -- 染色體群初始化
    local i = 0 -- 0 = 初代
    --宣告 初代族群
    local population = {}
    population[i] = {}

    for j = 1, size do
        -- 新增染色體物件，size個
        population[i][j] = Chromosomes:new(i)
        --生成 length 個0、1
        for k = 1, population[i][j].x_length do
            -- 填入 x 染色體
            population[i][j].x_binaryValue = population[i][j].x_binaryValue .. tostring(math.random(0, 1))
        end
        -- 填入 y 染色體
        for k = 1, population[i][j].y_length do
            population[i][j].y_binaryValue = population[i][j].y_binaryValue .. tostring(math.random(0, 1))
        end
        -- 設定適存值與對應 x , y值
        Chromosomes:setNumber(population[i][j])
        Chromosomes:setFitnessValue(population[i][j])
    end
    return population
end
--****************************突變******************************
function Chromosomes:mutation(obj)
    -- 選取位置
    local x_Position = math.random(1, obj.x_length)
    local y_Position = math.random(1, obj.y_length)
    -- x 染色體選到的位置 0-> 1、1->0
    if string.sub(obj.x_binaryValue, x_Position, x_Position) == "0" then
        obj.x_binaryValue =
            string.sub(obj.x_binaryValue, 1, x_Position - 1) ..
            "1" .. string.sub(obj.x_binaryValue, x_Position + 1, obj.x_length)
    elseif string.sub(obj.x_binaryValue, x_Position, x_Position) == "1" then
        obj.x_binaryValue =
            string.sub(obj.x_binaryValue, 1, x_Position - 1) ..
            "0" .. string.sub(obj.x_binaryValue, x_Position + 1, obj.x_length)
    end
    -- y 染色體選到的位置 0-> 1、1->0
    if string.sub(obj.y_binaryValue, y_Position, y_Position) == "0" then
        obj.y_binaryValue =
            string.sub(obj.y_binaryValue, 1, y_Position - 1) ..
            "1" .. string.sub(obj.y_binaryValue, y_Position + 1, obj.y_length)
    elseif string.sub(obj.y_binaryValue, y_Position, y_Position) == "1" then
        obj.y_binaryValue =
            string.sub(obj.y_binaryValue, 1, y_Position - 1) ..
            "0" .. string.sub(obj.y_binaryValue, y_Position + 1, obj.y_length)
    end
end

-- bubble sort 照適應值大小排序
function populationSort(population)
    for i = 1, #population do
        for j = 2, #population do
            if population[j - 1].fitnessValue < population[j].fitnessValue then
                population["temp"] = population[j - 1]
                population[j - 1] = population[j]
                population[j] = population["temp"]
            end
        end
    end
end
-- 輸出txt，excel 統計用
function output(population, fileName)
    -- open file
    local file = io.open(fileName, "w")
    local max = 0
    if nil == file then
        print("open file" .. fileName .. " fail")
    end

    local max_x = 0
    local max_y = 0
    -- input file
    file:write("generation,local_x,local_y,local_best,result,best_x,best_y,global_best\n")
    for i = 1, #population do
        if population[i][1].fitnessValue > max then
            max = population[i][1].fitnessValue
            max_x = population[i][1].x_number
            max_y = population[i][1].y_number
        end

        file:write(
            population[i][1].generation ..
                "," ..
                    population[i][1].x_number ..
                        "," ..
                            population[i][1].y_number ..
                                "," .. population[i][1].fitnessValue .. "," .. population[i][1].fxy .. "," .. max_x .. ",".. max_y .. ",".. max .. "\n"
        )
    end

    -- close file
    file:close()

    -- read the result
    local fileread = io.open(fileName, "r")

    local content = fileread:read("*a")
    print("file content is : \n")
    print(content)

    fileread:close()
end
