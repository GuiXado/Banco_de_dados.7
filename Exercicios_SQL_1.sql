--1) Consulta do nome do livro, valor unitário, editora e autor dos livros vendidos,
--sem repetição de registros
SELECT DISTINCT
	es.nome,
	es.valor,
	ed.nome,
	au.nome
FROM editora ed, autor au, estoque es, compra co
WHERE ed.codigo = es.codEditora
	AND au.codigo = es.codAutor
	AND es.codigo = co.codEstoque

--2) Consulta do nome do livro, quantidade comprada e valor da compra 15051
SELECT 
	es.nome,
	co.qtdComprada,
	co.valor
FROM estoque es, compra co
WHERE es.codigo	= co.codEstoque
	AND co.codigo = 15051

--3) Consulta do nome do livro e site da editora dos livros da Makron Books,
-- removendo 'www.' quando o site tiver mais de 10 caracteres
SELECT 
	es.nome,
	case
		when len(ed.site) > 10
		then replace(ed.site, 'www.', '')
		else ed.site
	end as site
FROM estoque es, editora ed
WHERE ed.codigo = es.codEditora
	AND ed.nome = 'Makron books'

--4) Consulta do nome do livro e breve biografia do autor David Halliday
SELECT
	es.nome,
	au.biografia
FROM autor au, estoque es
WHERE au.codigo = es.codAutor
	AND au.nome = 'David Halliday'

--5) Consulta do código da compra e quantidade comprada do livro Sistemas Operacionais Modernos
SELECT
	co.codigo,
	co.qtdComprada
FROM compra co, estoque es
WHERE es.codigo = co.codEstoque
	AND es.nome = 'Sistemas Operacionais Modernos'

--6) Consulta dos livros que não foram vendidos
SELECT 
	es.nome
FROM estoque es LEFT OUTER JOIN compra co
ON es.codigo = co.codEstoque
WHERE co.codEstoque IS NULL

--7) Consulta dos livros vendidos que não estão cadastrados,
-- removendo espaços extras no nome do livro
SELECT 
	TRIM(es.nome) as nome
FROM compra co LEFT OUTER JOIN estoque es
ON es.codigo = co.codEstoque
WHERE es.codigo IS NULL

--8) Consulta do nome e site da editora que não possui livros no estoque,
-- removendo 'www.' quando necessário
SELECT 
	ed.nome,
	case
		when len(ed.site) > 10
		then replace(ed.site, 'www.', '')
		else ed.site
	end as site
FROM editora ed LEFT OUTER JOIN estoque es
ON ed.codigo = es.codEditora
WHERE es.codEditora IS NULL

--9)  Consulta do nome e biografia dos autores sem livros no estoque,
-- substituindo 'Doutorado' por 'Ph.D.' na biografia
SELECT
	au.nome,
	case 
		when au.biografia LIKE 'Doutorado%'
		then replace(au.biografia, 'Doutorado', 'Ph.D.')
		else au.biografia
	end as biografia
FROM autor au LEFT OUTER JOIN estoque es
ON au.codigo = es.codAutor
WHERE es.codAutor IS NULL

--10) Consulta do nome do autor e o maior valor de livro no estoque,
-- ordenado por valor decrescente
SELECT
	au.nome,
	MAX(es.valor) as maior_Valor
FROM estoque es, autor au
WHERE au.codigo = es.codAutor
GROUP BY au.nome 
ORDER BY maior_Valor DESC

--11) Consulta do código da compra, total de livros comprados e soma dos valores gastos,
-- ordenado pelo código da compra em ordem crescente
SELECT
	co.codigo,
	SUM(co.qtdComprada) as qtdComprada, 
	SUM(co.valor) as valor
FROM compra co
GROUP BY co.codigo
ORDER BY co.codigo

--12) Consulta do nome da editora e média de preços dos livros em estoque,
-- ordenado pela média de valores em ordem crescente
SELECT
	ed.nome,
	CAST(AVG(es.valor) as decimal(7,2)) as prc_medio
FROM estoque es, editora ed
WHERE ed.codigo = es.codEditora
GROUP BY ed.nome
ORDER BY prc_medio ASC

--13) Consulta do nome do livro, quantidade em estoque, editora, site da editora e status do estoque:
-- (menos de 5: "Produto em Ponto de Pedido",
-- entre 5 e 10: "Produto Acabando",
-- acima de 10: "Estoque Suficiente"),
-- ordenado por quantidade em estoque
SELECT
	es.nome,
	es.quantidade,
	ed.nome,
	case
		when len(ed.site) > 10
		then replace(ed.site, 'www.', '')
		else ed.site
	end as site,
	case
		when es.quantidade < 5 then 'Produto em Ponto de Pedido'
		when es.quantidade <= 10 then 'Produto Acabando'
		else 'Estoque Suficiente'
	end as status
FROM estoque es, editora ed
WHERE ed.codigo = es.codEditora
ORDER BY es.quantidade ASC

--14) elatório com código do livro, nome do livro, nome do autor e informações da editora (nome + site),
-- concatenando apenas sites não nulos
SELECT
	es.codigo,
	es.nome,
	au.nome,
	case
		when ed.site IS NOT NULL
		then ed.nome + ' | ' + ed.site
		else ed.nome
	end as info_editora
FROM estoque es, autor au, editora ed
WHERE au.codigo = es.codAutor
	AND ed.codigo = es.codEditora

--15) Consulta do código da compra, diferença em dias e meses desde a data da compra até hoje
SELECT
	co.codigo,
	datediff(day, co.dataCompra, getdate()) as dias,
	datediff(month, co.dataCompra, getdate()) as meses
FROM compra co

--16) Consulta do código da compra e soma dos valores gastos,
-- apenas para compras com total maior que 200
SELECT
	co.codigo,
	SUM(co.valor)
FROM compra co
GROUP BY co.codigo
HAVING SUM(co.valor) > 200