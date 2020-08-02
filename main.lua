-- variable : 儲存變數的類別
-- lowerBound : 下限
-- upperBound : 上限
-- precision : 精度
--  Chromosomes : 儲存染色體的類別
-- generation : 第幾代
-- length : 染色體長度
-- binaryValue : 二元值
-- number : 染色體在目標函式中對應的 x or y 值
-- fitnessValue : 適存值
-- probability : 被選中的機率
-- cumulativeProbability : 累加的機率
-- population[i][j] : 族群，i 為第幾代、j 為第幾條
-- populationSize : 族群大小
-- generation : 代數大小
-- crossoverRate : 交配率
-- mutationRate : 突變率
require "lib"

-- 主程式
local function main()
    -- 設置時間種子
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))
    -- 初始化

    --宣告染色體型態
    x = variable:new(nil, 3, 4, 3)
    y = variable:new(nil, -2, 2, 3)

    local populationSize = 100
    local generation = 100
    local crossoverRate = 0.8
    local mutationRate = 0.08
    local population = Chromosomes:initialization(populationSize)

    local i = 0
    local j = 1
    while i < generation do
        --子代族群宣告
        population[i + 1] = {}
        population[i + 1][j] = Chromosomes:new(i + 1)

        while #population[i + 1] <= populationSize do
            -- 族群由適存值大小排列
            populationSort(population[i])
            -- print("\n\n\t\t\t*****************************挑選*****************************\n")
            local k = 1
            -- 交配池初始化
            local poor = {}
            while k <= 2 do
                -- 計算每條染色體的選中機率及累加機率
                Chromosomes:setProbability(population[i])
                -- 產生0~1之間的亂數
                local r = math.random()
                -- 被選中的染色體
                for j = 1, #population[i] do
                    if r <= population[i][j].cumulativeProbability then
                        -- 選中的放進交配池
                        poor[k] = population[i][j]
                        -- 從母體移除進入交配池的染色體
                        table.remove(population[i], j)
                        k = k + 1
                        break
                    end
                end
            end
            --      print("\n\n\t\t\t*****************************交配*****************************\n")
            Pc = math.random()

            if Pc < crossoverRate then
                --子代暫存
                local offspringTemp = {}
                for n = 1, 2 do
                    offspringTemp[n] = Chromosomes:new(i + 1)
                    -- 單點交換的位置
                    local exchangePoint = {}
                    exchangePoint[x] = math.random(1, poor[n].x_length - 1)
                    exchangePoint[y] = math.random(1, poor[n].y_length - 1)
                    -- 交換基因，賦予 二元值
                    offspringTemp[n].x_binaryValue =
                        string.sub(poor[n].x_binaryValue, 1, exchangePoint[x]) ..
                        string.sub(poor[3 - n].x_binaryValue, exchangePoint[x] + 1, poor[n].x_length)
                    offspringTemp[n].y_binaryValue =
                        string.sub(poor[n].y_binaryValue, 1, exchangePoint[y]) ..
                        string.sub(poor[3 - n].y_binaryValue, exchangePoint[y] + 1, poor[n].y_length)
                    -- 突變
                    Mr = math.random()
                    if Mr < mutationRate then
                        Chromosomes:mutation(offspringTemp[n])
                    end
                    -- 子代賦予值
                    Chromosomes:setNumber(offspringTemp[n])
                    Chromosomes:setFitnessValue(offspringTemp[n])

                    --檢查到最後一個染色體
                    if #population[i + 1] <= populationSize then
                        for c, _ in ipairs(population[i + 1]) do
                            --如果子代族群中重覆染色體 x
                            if offspringTemp[n].x_binaryValue == population[i + 1][c].x_binaryValue then
                                --不存
                                break
                            elseif offspringTemp[n].y_binaryValue == population[i + 1][c].y_binaryValue then
                                --如果子代族群中重覆染色體 y
                                --不存
                                break
                            elseif c == #population[i + 1] then
                                --存入
                                population[i + 1][#population[i + 1]]= offspringTemp[n]
                                population[i + 1][#population[i + 1] + 1] = Chromosomes:new(i + 1)

                                break
                            end
                        end
                    end
                end
            end
            -- 交配完的染色體歸還母池
            for k = 1, 2 do
                table.insert(population[i], poor[k])
            end
        end
        -- 前面多新增了一個Chromosomes 物件，必須移除
        table.remove(population[i + 1])
        i = i + 1
    end
    -- 輸出結果到文字檔中
    output(population, "result.csv")
end
main()
