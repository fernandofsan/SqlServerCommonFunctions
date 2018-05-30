create or alter function [dbo].[Slugify](@str nvarchar(max)) returns nvarchar(max)
as
begin
    declare @IncorrectCharLoc int
    set @str = replace(replace(lower(@str),'.',' '),'''','')
	-- remoce accents
	set @str  =  convert(varchar(512), @str) collate Cyrillic_General_CI_AI
    -- remove non alphanumerics:
    set @IncorrectCharLoc = patindex('%[^0-9a-z -]%',@str)
    while @IncorrectCharLoc > 0
    begin
        set @str = stuff(@str,@incorrectCharLoc,1,' ')
        set @IncorrectCharLoc = patindex('%[^0-9a-z -]%',@str)
    end
    -- remove consecutive spaces:
    while charindex('  ',@str) > 0
    begin
    set @str = replace(@str, '  ', ' ')
    end
    set @str = replace(@str,' ','-')
return @str
end
GO
