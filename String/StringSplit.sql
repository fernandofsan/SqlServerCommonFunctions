CREATE FUNCTION [dbo].[StringSplit](@input NVARCHAR(MAX), @delimiter CHAR(1)=',') 
	RETURNS @returnTable TABLE(item NVARCHAR(100)) AS  
BEGIN 
    IF @input IS NULL RETURN;
    DECLARE @currentStartIndex INT, @currentEndIndex INT,@length INT;
    SET @length=LEN(@input);
    SET @currentStartIndex=1;

    SET @currentEndIndex=CHARINDEX(@delimiter,@input,@currentStartIndex);
    WHILE (@currentEndIndex<>0)
        BEGIN
        INSERT INTO @returnTable VALUES (LTRIM(SUBSTRING(@input, @currentStartIndex, @currentEndIndex-@currentStartIndex)))
        SET @currentStartIndex=@currentEndIndex+1;
        SET @currentEndIndex=CHARINDEX(@delimiter,@input,@currentStartIndex);
        END

    IF (@currentStartIndex <= @length)
        INSERT INTO @returnTable 
        VALUES (LTRIM(SUBSTRING(@input, @currentStartIndex, @length-@currentStartIndex+1)));
    RETURN;
END;