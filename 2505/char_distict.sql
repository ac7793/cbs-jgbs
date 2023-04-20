-- 在 gbase 上编写一个对字符串排序并去重的存储函数，可以按照以下步骤进行：
-- 1. 创建一个存储函数，定义函数名称和输入参数类型和数量，例如：
-- 2. 在函数中添加代码，以去除字符串中的 0 和重复字符。可以使用以下代码：

CREATE FUNCTION sort_and_remove_duplicates(str VARCHAR(100)) RETURNS VARCHAR(100)

BEGIN
IF str IS NULL OR str = '' THEN
  RETURN '0';
END IF;
 
DECLARE result VARCHAR(100) DEFAULT '';
DECLARE c char DEFAULT '';
DECLARE i INT DEFAULT 1;
 
WHILE i <= LENGTH(str) DO
set c = SUBSTRING(str, i, 1);
  IF c != '0' AND LOCATE(c, result) = 0 THEN
    SET result = CONCAT(result, c);
  END IF;
 
  SET i = i + 1;
END WHILE;

-- 3. 对结果进行排序，可以使用以下代码：

SET result = (SELECT GROUP_CONCAT(DISTINCT digit ORDER BY digit SEPARATOR '') 
FROM (SELECT SUBSTRING(result, x, 1) AS digit FROM (SELECT @x := @x + 1 AS x 
FROM information_schema.columns JOIN (SELECT @x := 0) a WHERE @x < LENGTH(result)) t WHERE x <= LENGTH(result)) s);

-- 4. 最后，将结果返回，例如：

RETURN result;
end;


-- 完整的存储函数代码如下：

CREATE FUNCTION sort_and_remove_duplicates(str VARCHAR(100)) RETURNS VARCHAR(100)
BEGIN
  IF str IS NULL OR str = '' THEN
    RETURN '0';
  END IF;
   
  DECLARE result VARCHAR(100) DEFAULT '';
  DECLARE i INT DEFAULT 1;
   
  WHILE i <= LENGTH(str) DO
    IF SUBSTRING(str, i, 1) != '0' AND LOCATE(SUBSTRING(str, i, 1), result) = 0 THEN
      SET result = CONCAT(result, SUBSTRING(str, i, 1));
    END IF;
   
    SET i = i + 1;
  END WHILE;
   
  SET result = (SELECT GROUP_CONCAT(DISTINCT digit ORDER BY digit SEPARATOR '') FROM (SELECT SUBSTRING(result, x, 1) AS digit FROM (SELECT @x := @x + 1 AS x FROM
  
  information_schema.columns JOIN (SELECT @x := 0) a WHERE @x < LENGTH(result)) t WHERE x <= LENGTH(result)) s);
   
  RETURN result;
END;
```
使用方法：
```
SELECT sort_and_remove_duplicates('00012301212'); -- 输出 123
SELECT sort_and_remove_duplicates('00321123'); -- 输出 123
SELECT sort_and_remove_duplicates(''); -- 输出 0
SELECT sort_and_remove_duplicates(NULL); -- 输出 0
```