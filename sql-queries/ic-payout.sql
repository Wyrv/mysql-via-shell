SELECT b2.id AS ID_CONTA,upper(lastname) AS PARCEIRO,round(sum(sessionbill),2) AS VALOR 
FROM BANCO.TABELA1 b1, BANCO.TABELA2 b2 
WHERE b1.card_id = b2.id 
AND b1.starttime >= '*Y_INI*-*M_INI*-*D_INI* 00:00:00' 
AND b1.starttime <= '*Y_END*-*M_END*-*D_END* 23:59:59' 
GROUP BY b2.id
