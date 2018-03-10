DROP FUNCTION IF EXISTS dbo.fullTextConvertStringIntoContainsFilters
GO

CREATE FUNCTION dbo.fullTextConvertStringIntoContainsFilters(@SEARCH_TERMS_AS_STRING NVARCHAR(MAX)) 
RETURNS NVARCHAR(MAX) AS  
BEGIN 
	IF @SEARCH_TERMS_AS_STRING IS NULL RETURN '';	
	DECLARE @RESULT NVARCHAR(MAX) = ''
	DECLARE @INDEX INT = 1
	DECLARE @ARRAY_SIZE INT = (SELECT COUNT(*) FROM dbo.StringSplit(@SEARCH_TERMS_AS_STRING, ' '));

	DECLARE @SEARCH_TERMS TABLE (ITEM VARCHAR(MAX), ROW_NUMBER INT)

	-- Ordena os termos de pesquisa pela ordem original, A ordem � necess�ria para definir o index de cada um
	INSERT INTO @SEARCH_TERMS
	SELECT 
		ITEM, 
		ROW_NUMBER() OVER (ORDER BY (SELECT 0)) AS ROW_NUMBER
	FROM 
		dbo.StringSplit(@SEARCH_TERMS_AS_STRING, ' ')

	DECLARE @AUXILIAR_TERM VARCHAR(MAX)
	WHILE (@INDEX <= @ARRAY_SIZE)
	BEGIN  
		SELECT @AUXILIAR_TERM = CONCAT('CONTAINS(*, ''"*', ITEM ,'*"'')') FROM @SEARCH_TERMS WHERE ROW_NUMBER = @INDEX
	
		SELECT @RESULT = (CASE WHEN (@INDEX = 1 )
							THEN  @AUXILIAR_TERM
							ELSE @RESULT + CONCAT(' AND ', @AUXILIAR_TERM) 
						  END)

		SET @INDEX = @INDEX + 1
	END  

	RETURN @RESULT;
END;