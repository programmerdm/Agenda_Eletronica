{
Nome Do Programa... Agenda Eletrônica;
Função............. Operar Como Uma Agenda Eletrônica;
Plataforma......... GNU/Linux;
Criado Por......... Daniel Melo;
Disciplina......... Lógica De Programação II;
Professor.......... Wender Magno Cota;
}
program Agenda_Eletronica;
uses crt;
//Tipos de arquivos
type tstr60 = string[60];

	 treg_pes = record
                	id:integer;
                	nome:string[20];
                end;
     tarq_pes = file of treg_pes;

     treg_tel = record
     				id:integer;
                	tel:string[8];
                end;
     tarq_tel = file of treg_tel;

     treg_email = record
     				id:integer;
                  	email:string[50];
            	  end;
     tarq_email = file of treg_email;
// variaveis globais
var arq_pes:tarq_pes;				// id_p, id_e, id_t são contadores para verificar se tem algo gravado nos arquivos
	arq_tel:tarq_tel;				
	arq_email:tarq_email;			
	r_email:treg_email;
	r_tel:treg_tel;
	email,tel:tstr60;
    cod,id_p,id_e,id_t,i:integer;
    opcao,sair:char;
    abriu,achou:boolean;
//BORDA
procedure borda;
var i:integer;
begin
	// borda horizontal cima
     for i := 10 to 60 do
     begin
          gotoxy(i,2);
          write('-');
     end;
     // borda vertical esquerda
     for i := 3 to 23 do
     begin
          gotoxy(10,i);
          write('|');
     end;
     // borda vertical direita
     for i:= 3 to 23 do
     begin
          gotoxy(60,i);
          write('|');
     end;
     // borda horizontal baixo
     for i := 10 to 60 do
     begin
          gotoxy(i,23);
          write('-');
     end;
end;
//Validação do id do arquivo de contato
function val_id_pes(var arq_pes:tarq_pes; var cod:integer):integer;
var r:treg_pes;
	i:integer;
	achou:boolean;
begin
	seek(arq_pes,0);
	i := 0 ;
	achou := false;
	while (EOF(arq_pes) = false) and (achou = false) do
	begin
		read(arq_pes,r);
		if r.id = cod then
			achou := true
		else
			i := i + 1;
	end;
	if achou = true then
		val_id_pes := i
	else
		val_id_pes := -1;
end;
//Validação do id do arquivo de telefone retorna a posicao se encontrar e -1 senao
function val_id_tel(var arq_tel:tarq_tel; var cod:integer):integer;
var r:treg_tel;
	i:integer;
	achou:boolean;
begin
	seek(arq_tel,0);
	i := 0;
	achou := false;
	while (EOF(arq_tel) = false) and (achou = false) do
	begin
		read(arq_tel,r);
		if r.id = cod then
			achou := true
		else
			i := i + 1;
	end;
	if achou = true then
		val_id_tel := i
	else
		val_id_tel := -1;
end;
//Validação do id do arquivo de contato retorna a posicao se encontrar e -1 senao
function val_id_email(var arq_email:tarq_email; var cod:integer):integer;
var r:treg_email;
	i:integer;
	achou:boolean;
begin
	seek(arq_email,0);
	i := 0;
	achou := false;
	while (EOF(arq_email) = false) and (achou = false) do
	begin
		read(arq_email,r);
		if r.id = cod then
			achou := true
		else
			i := i + 1;
	end;
	if achou = true then
		val_id_email := i
	else
		val_id_email := -1;
end;
// Function conversor para a caixa maior
function converte(s:tstr60) : tstr60;
var i:integer;
begin
	for i := 1 to length(s) do
		s[i] := upcase(s[i]);
	converte := s;
end;
// Validando o nome retorana a posicao se encontrar e -1 senao
function pesq_pessoa_nome(var a:tarq_pes; n:string):integer;
var posicao:integer;
	r:treg_pes;
	achou:boolean;
begin
	posicao := 0;
	seek(a,0);
	achou := false;
	while (eof(a) = false) and (achou = false) do
	begin
		read(a,r);
		if r.nome = n then
			achou := true
		else
			posicao := posicao + 1;
	end;
	if achou = true then
		pesq_pessoa_nome := posicao
	else
		pesq_pessoa_nome := -1;
end;

// Verificando o último ID cadastrado no arquivo de contatos
function maior_id_pessoa(var a:tarq_pes):integer;
var maior:integer;
	r_pes:treg_pes;
begin
	maior := 0;
	seek(a,0);
	while eof(a) = false do
	begin
		read(a,r_pes);
		if r_pes.id > maior then
			maior := r_pes.id;
	end;
	maior_id_pessoa := maior;
end;

// Verificando o último ID cadastrado no arquivo de emails
function maior_id_email(var a:tarq_email):integer;
var maior:integer;
	r_email:treg_email;
begin
	maior := 0;
	seek(a,0);
	while eof(a) = false do
	begin
		read(a,r_email);
		if r_email.id > maior then
			maior := r_email.id;
	end;
	maior_id_email := maior;
end;

// Verificando o último ID cadastrado no arquivo de telefones
function maior_id_tel(var a:tarq_tel):integer;
var maior:integer;
	r_tel:treg_tel;
begin
	maior := 0;
	seek(a,0);
	while eof(a) = false do
	begin
		read(a,r_tel);
		if r_tel.id > maior then
			maior := r_tel.id;
	end;
	maior_id_tel := maior;
end;

//cadastro de pessoas
procedure cad_pessoa(var a:tarq_pes);
var r:treg_pes;
	i,cancel:integer;
begin
	repeat
		clrscr;
		borda;
		gotoxy(22,4);writeln('     Agenda Eletrônica');
		gotoxy(22,5);writeln('____________________________');
		gotoxy(24,7);writeln('Inserção De Novos Nomes:');
		gotoxy(22,9);writeln('____________________________');
		gotoxy(24,12);write('Nome: ');
		gotoxy(22,19);writeln('Pressione Enter Para Cancelar.');
		gotoxy(30,12);readln(r.nome);
		if r.nome = '' then
			cancel := 0
		else
		begin
			cancel := 1;
			r.nome := converte(r.nome);
			i := pesq_pessoa_nome(a,r.nome);
			if i <> -1 then
			begin
				gotoxy(24,12);clreol;
				gotoxy(22,19);clreol;
				gotoxy(29,12);clreol;
				borda;
				gotoxy(29,12);write('Nome Repetido!');
				gotoxy(49,12);delay(3000);
			end;
		end;
	until (i = -1) or (cancel = 0);
	if cancel = 1 then
	begin
		id_p := maior_id_pessoa(a)+ 1;
		r.id := id_p;
		seek(a,filesize(a));
		write(a,r);
		gotoxy(24,12);clreol;
		gotoxy(22,19);clreol;
		gotoxy(23,12);clreol;
		borda;
		gotoxy(33,12);write('Salvo!');
		gotoxy(39,12);delay(3000);
	end
	else
	begin
		clrscr;
		borda;
		gotoxy(20,12);writeln('Operação Cancelada Pelo Usuário...');
		gotoxy(53,12);delay(3000);
	end;
end;
//Validar o telefone
//retorna -1 se não encontrar
function pesq_pessoa_tel(var a:tarq_tel; var tel:tstr60):integer;
var pos:integer;
	r:treg_tel;
	achou:boolean;
begin
	pos := 0;
	seek(a,0);
	achou := false;
	while (eof(a) = false) and (achou = false) do
	begin
		read(a,r);
		if r.tel = tel then
			achou := true
		else
			pos := pos + 1;
	end;
	if achou = true then
		pesq_pessoa_tel := pos
	else
		pesq_pessoa_tel := -1;
end;
//Cadastro de telefones
procedure cad_tel(var arq_pes:tarq_pes; var arq_tel:tarq_tel; var cod:integer);
var r_pes:treg_pes;
	r_tel:treg_tel;
	achou:boolean;
	i,k,cont_num,cancel:integer;
begin
	i := val_id_pes(arq_pes,cod);
	if i <> -1 then
	begin
		repeat
			repeat
				clrscr;
				borda;
				achou := false;
				seek(arq_pes,i);
				read(arq_pes,r_pes);
				gotoxy(22,4);writeln('     Agenda Eletrônica');
				gotoxy(22,5);writeln('____________________________');
				gotoxy(24,7);writeln('Inserção De Novos Telefones:');
				gotoxy(22,9);writeln('____________________________');
				gotoxy(24,12);writeln('Nome: ',r_pes.nome);
				gotoxy(22,19);writeln('Pressione Enter Para Cancelar.');
				gotoxy(24,13);write('Telefone: ');
				readln(r_tel.tel);
				if r_tel.tel = '' then
					cancel := 0
				else
				begin
					cancel := 1;
					achou := false;
				    for k := 1 to length(r_tel.tel) do
					    if (r_tel.tel[k] <> '0') and (r_tel.tel[k] <> '1') and (r_tel.tel[k] <> '2') and (r_tel.tel[k] <> '3') and (r_tel.tel[k] <> '4') and (r_tel.tel[k] <> '5') and (r_tel.tel[k] <> '6') and (r_tel.tel[k] <> '7') and (r_tel.tel[k] <> '8') and (r_tel.tel[k] <> '9') then
					  	     achou := true;
				    if achou = true then
				    begin
				    	gotoxy(24,12);clreol;
				    	gotoxy(24,13);clreol;
						gotoxy(22,19);clreol;
						gotoxy(24,12);clreol;
						borda;
						gotoxy(24,12);writeln('Digite Apenas Números!');
				        gotoxy(49,12);delay(3000);
				    end
				    else
				    begin
				    	cont_num := length(r_tel.tel);
				    	if (cont_num < 8) then
						begin
							achou := true;
							gotoxy(24,12);clreol;
							gotoxy(24,13);clreol;
							gotoxy(22,19);clreol;
							gotoxy(23,12);clreol;
							borda;
							gotoxy(14,12);writeln('O Telefone Deve Conter No Mínimo 8 Dígitos!');
						    gotoxy(57,12);delay(3000);
						end;
					end;
				end;
			until (achou = false) or (cancel = 0);
			//validando o telefones
			i := pesq_pessoa_tel(arq_tel,r_tel.tel);
			if i <> -1 then
			begin				
				achou := true;
				gotoxy(24,12);clreol;
				gotoxy(24,13);clreol;
				gotoxy(22,19);clreol;
				gotoxy(23,12);clreol;
				borda;
				gotoxy(29,12);write('Número Repetido!');
				gotoxy(49,12);delay(3000);
			end;
		until achou = false;
		if cancel = 1 then
		begin
			r_tel.id := cod;
			id_t := id_t + 1;
			seek(arq_tel,filesize(arq_tel));
			write(arq_tel,r_tel);
			gotoxy(24,12);clreol;
	    	gotoxy(24,13);clreol;
			gotoxy(22,19);clreol;
			gotoxy(23,12);clreol;
			borda;
			gotoxy(33,12);writeln('Salvo!');
			gotoxy(38,12);delay(3000);
		end
		else
		begin
			clrscr;
			borda;
			gotoxy(20,12);writeln('Operação Cancelada Pelo Usuário...');
			gotoxy(53,12);delay(3000);
		end;
	end
	else
	begin
		clrscr;
		borda;
		gotoxy(23,12);writeln('Contato Não Encontrado!');
		gotoxy(46,12);delay(3000);
	end;
end;


//Validar o EMAIL
//retorna -1 se não encontrar ou 0 se tiver encontrado
function pesq_pessoa_email(var a:tarq_email; var email:tstr60):integer;
var pos:integer;
	r:treg_email;
	achou:boolean;
begin
	pos := 0;
	seek(a,0);
	achou := false;
	while (eof(a) = false) and (achou = false) do
	begin
		read(a,r);
		if r.email = email then
			achou := true
		else
			pos := pos + 1;
	end;
	if achou = true then
		pesq_pessoa_email := 0
	else
		pesq_pessoa_email := -1;
end;
//validação do dominio retorna 1 se valido e -1 senão
function dominio_existente(email:string):integer;
var lista_email:array[1..5] of string;
	final_email:string;
	pos_arroba,i:integer;
	valido:boolean;
Begin
	valido := false;
	final_email := '';
	pos_arroba := 0;
	i := 0;
	lista_email[1]:='HOTMAIL.COM';
	lista_email[2]:='GMAIL.COM';
	lista_email[3]:='YAHOO.COM.BR';
	lista_email[4]:='BOL.COM.BR';
	lista_email[5]:='OUTLOOK.COM';
	for i := 1 to length(email) do
		if email[i] = '@' then 
		begin 
			pos_arroba := i;
			break;
		end;
		//-------------------------------------------------//
	if pos_arroba <> 0 then
	begin
		for i := pos_arroba + 1 to length(email) do
			final_email:=final_email+email[i];
		final_email := upcase(final_email);
		for i := 1 to 5 do
			if final_email = lista_email[i] then 
			begin 
				valido := true;
				break;
			end;
	end;
	if valido = true then
		dominio_existente := 1
	else
		dominio_existente := -1
end;
//Cadastro de emails
procedure cad_email(var arq_pes:tarq_pes; var arq_email:tarq_email; var cod:integer);
var r_pes:treg_pes;
	r_email:treg_email;
	achou,valido:boolean;
	i,aux,cancel:integer;
begin
	i := val_id_pes(arq_pes,cod);
	if i <> -1 then
	begin
		id_e := id_e + 1;
		r_email.id := cod;
		repeat
			clrscr;
			borda;
			seek(arq_pes,i);
			read(arq_pes,r_pes);
			gotoxy(22,4);writeln('     Agenda Eletrônica');
			gotoxy(22,5);writeln('____________________________');
			gotoxy(24,7);writeln('Inserção De Novos E-mails:');
			gotoxy(22,9);writeln('____________________________');
			gotoxy(24,12);writeln('Nome: ',r_pes.nome);
			gotoxy(22,19);writeln('Pressione Enter Para Cancelar.');
			gotoxy(24,13);write('E-mail: ');
			gotoxy(32,13);readln(email);
			if email = '' then
				cancel := 0
			else
			begin
				cancel := 1;
				// Verificando se o dominio do email
				valido := true;
				if dominio_existente(email) = -1 then
				begin
					valido := false;
					achou := true;
					gotoxy(24,12);clreol;
					gotoxy(24,13);clreol;
					gotoxy(22,19);clreol;
					gotoxy(24,12);clreol;
					borda;
					gotoxy(29,12);writeln('E-mail Inválido!');
					gotoxy(45,12);delay(3000);
				end
				else
				begin
				// verificando se o email ja esta cadastrado
					achou := false;
					aux := pesq_pessoa_email(arq_email,email);
					if aux <> -1 then
					begin
						achou := true;
						gotoxy(24,12);clreol;
						gotoxy(24,13);clreol;
						gotoxy(22,19);clreol;
						gotoxy(24,12);clreol;
						borda;
						gotoxy(27,12);write('E-mail Já Cadastrado!');
						gotoxy(49,12);delay(3000);
					end;
				end;
			end;
		until (achou = false) and (valido = true) or (cancel = 0);
		//Salvando o email		
		if achou = false then
		begin
			r_email.email := email;
			seek(arq_email,filesize(arq_email));
			write(arq_email,r_email);
			gotoxy(24,13);clreol;
			gotoxy(22,19);clreol;
			gotoxy(23,12);clreol;
			borda;
			gotoxy(33,12);writeln('Salvo!');
			gotoxy(38,12);delay(3000);
		end
		else
			if cancel = 0 then
			begin
				id_e := id_e - 1;
				clrscr;
				borda;
				gotoxy(20,12);writeln('Operação Cancelada Pelo Usuário...');
				gotoxy(53,12);delay(3000);
			end;
	end
	else
	begin
		clrscr;
		borda;
		gotoxy(23,12);writeln('Contato Não Encontrado!');
		gotoxy(46,12);delay(3000);
	end;
end;

//Consultar a agenda
procedure consulta(var arq_pes:tarq_pes; var arq_email:tarq_email; var arq_tel:tarq_tel; var cod:integer);
var r_pes:treg_pes;
	r_email:treg_email;
	r_tel:treg_tel;
	i,t,e:integer;
	achou:boolean;
begin
    clrscr;
    //Procurando o ID
	i := val_id_pes(arq_pes,cod);
	if i <> -1 then
	begin
		borda;
		seek(arq_pes,i);
		read(arq_pes,r_pes);
		gotoxy(22,4);writeln('    Agenda Eletrônica');
		gotoxy(22,5);writeln('____________________________');
		gotoxy(22,7);writeln(' Menu De Consulta De dados');
		gotoxy(22,8);writeln('____________________________');
		gotoxy(22,10);writeln('Informações Do Contato:');
	    gotoxy(22,12);writeln('ID      : ',r_pes.id);
        gotoxy(22,13);writeln('Nome    : ',r_pes.nome);
        seek(arq_tel,0);
        achou := false;
        t := 14;
        while (eof(arq_tel) = false) do
        begin
        	read(arq_tel,r_tel);
        	if r_tel.id = cod then
        	begin
        		achou := true;
	            gotoxy(22,t);writeln('Telefone: ',r_tel.tel,';');
	            t := t + 1;
	        end;
	    end;
	    if achou = false then
	    begin
	    	gotoxy(22,t);writeln('Telefone: Nenhum Telefone Cadastrado;');
	    end;
	    achou := false;
        seek(arq_email,0);
        e := t + 1;
        while eof(arq_email) = false do
        begin
        	read(arq_email,r_email);
        	if r_email.id = cod then
        	begin
        		achou := true;
	            gotoxy(22,e);writeln('E-mail  : ',r_email.email,';');
	            e := e + 1;
	        end;
	    end;
	    if achou = false then
	    begin
	    	gotoxy(22,e);writeln('E-mail  : Nenhum E-mail Cadastrado;');
	    end;
	end
	else
	begin
		clrscr;
		borda;
		gotoxy(23,12);writeln('Contato Não Encontrado!');
		gotoxy(53,12);delay(3000);
	end;
end;

//Deletar telefones
function del_tel(var arq_tel:tarq_tel; var cod:integer; var tel:tstr60):integer;
var	r_tel:treg_tel;
	i:integer;
begin
	i := pesq_pessoa_tel(arq_tel,tel);
	if i <> -1 then
	begin
		//Excluindo telefone
		seek(arq_tel,filesize(arq_tel)-1);
		read(arq_tel,r_tel);
		seek(arq_tel,i);
		write(arq_tel,r_tel);
		seek(arq_tel,filesize(arq_tel)-1);
		truncate(arq_tel);
		del_tel := 1;
		id_t := id_t - 1;
	end
	else
		del_tel := -1;
end;

//Deletar email's
function del_email(var arq_email:tarq_email; var cod:integer; var email:tstr60):integer;
var r_email:treg_email;
	i:integer;
begin
	i := pesq_pessoa_email(arq_email,email);
	if i <> -1 then
	begin
		//Excluindo email
		seek(arq_email,filesize(arq_email)-1);
		read(arq_email,r_email);
		seek(arq_email,i);
		write(arq_email,r_email);
		seek(arq_email,filesize(arq_email)-1);
		truncate(arq_email);
		del_email := 1;
		id_e := id_e - 1;
	end
	else
		del_email := -1;
 end;

 // listagem
procedure listagem (var a:tarq_pes);
var r_pes:treg_pes;
	i,k,cont,tam:integer;
begin
	clrscr;
	borda;
	gotoxy(22,4);writeln('    Agenda Eletrônica   ');
	gotoxy(22,5);writeln('____________________________');
	gotoxy(22,7);writeln('     Menu de Contatos');
	gotoxy(22,8);writeln('____________________________');
	gotoxy(22,10);writeln('Contatos:');
	gotoxy(22,12);writeln('IDs  -  Nomes');
	gotoxy(22,13);writeln('____________________________');
	seek(a,0);
	cont := 0;
	k := 0;
	i := 14;
	tam := filesize(a) - 1;
	while (k <= tam) do
	begin
		read(a,r_pes);
		gotoxy(23,i);clreol;writeln(r_pes.id,'    -   ',r_pes.nome);
		borda;
		i := i + 1;
		cont := cont + 1;
		k := k + 1;
		if  (k mod 5 = 0) then
		begin
			if k < tam then
			begin
				gotoxy(22,i + 1);write('Pressione Enter Para Ver Mais');
				gotoxy(51,i + 1);readkey;
				for cont := 14 to 20 do
				begin
					gotoxy(22,cont);clreol;
				end;
				cont := 0;
				i:= 14;
			end;
		end;
	end;
end;
// deletar uma pessoa e todos seus dados
procedure deletar_pes(var arq_pes:tarq_pes; var arq_tel:tarq_tel; var arq_email:tarq_email; var cod:integer);
var r_pes:treg_pes;
	r_email:treg_email;
	r_tel:treg_tel;
	i:integer;
begin
	//Excluindo contato cadastrado
	i := val_id_pes(arq_pes,cod);
	if i <> - 1 then
	begin
		clrscr;
		seek(arq_pes,filesize(arq_pes)-1);
		read(arq_pes,r_pes);
		seek(arq_pes,i);
		write(arq_pes,r_pes);
		seek(arq_pes,filesize(arq_pes)-1);
		truncate(arq_pes);
		id_p := id_p - 1;
		//Excluindo telefone do contato caso tenha algum cadastrado
		if id_t > 0 then
		begin
			i := val_id_tel(arq_tel,cod);
			seek(arq_tel,0);
			while (eof(arq_tel) = false) and (i > -1 )do
			begin
				seek(arq_tel,filesize(arq_tel)-1);
				read(arq_tel,r_tel);
				seek(arq_tel,i);
				write(arq_tel,r_tel);
				seek(arq_tel,filesize(arq_tel)-1);
				truncate(arq_tel);
				id_t := id_t - 1;
				i := val_id_tel(arq_tel,cod);
			end;
		end;
		//Excluindo email do contato caso tenha algum cadastrado
		if id_e > 0 then
		begin
			i := val_id_email(arq_email,cod);
			seek(arq_email,0);
			while (eof(arq_email) = false) and (i > -1) do
			begin
				seek(arq_email,filesize(arq_email)-1);
				read(arq_email,r_email);
				seek(arq_email,i);
				write(arq_email,r_email);
				seek(arq_email,filesize(arq_email)-1);
				truncate(arq_email);
				id_e := id_e - 1;
				i := val_id_email(arq_email,cod);
			end;
		end;
		clrscr;
		borda;
		gotoxy(23,12);writeln('Contato Deletado Com Sucesso!!');
		gotoxy(53,12);delay(3000);
	end
	else
	begin
		clrscr;
		borda;
		gotoxy(23,12);writeln('Contato Não Encontrado!');
		gotoxy(48,12);delay(3000);
	end;
end;
// Deletar todos os contatos da agenda
procedure del_all(var arq_pes:tarq_pes; var arq_tel:tarq_tel; var arq_email:tarq_email);
var opcao:char;
begin
	borda;
	gotoxy(19,21);write('Tem Certeza Que Deseja Excluir');
	gotoxy(19,22);write('Todos Os Contatos [S/N]: ');
	readln(opcao);
	opcao := upcase(opcao);
	if (opcao = 'S') and (id_p > 0) then
	begin
		clrscr;
		// Apagando o arquivo de pessoas
		seek(arq_pes,0);
		truncate(arq_pes);
		id_p := 0;
		// Apagando o arquivo de email
		seek(arq_email,0);
		truncate(arq_email);
		id_e := 0;
		// Apagando o arquivo de telefone
		seek(arq_tel,0);
		truncate(arq_tel);
		id_t := 0;
		borda;
		gotoxy(20,12);writeln('Todos Os Contatos Foram Deletados!');
		gotoxy(53,12);delay(3000);
	end
	else
	begin
		clrscr;
		borda;
		gotoxy(20,12);writeln('Operação Cancelada Pelo Usuário...');
		gotoxy(53,12);delay(3000);
	end;
end;

//corpo do programa Principal
begin
	clrscr;
	// Abertura do arquivo de pessoas
	assign(arq_pes,'contatos.dat');
    {$I-}  {desligando a verificação de eros de IO}
    reset(arq_pes);
    abriu := true;
    if IOResult <> 0 then
    begin
    	Rewrite(arq_pes);
    	if IOResult <> 0 then
    		abriu := false;
    end;
    // Abertura do arquivo de telefones
    assign(arq_tel,'telefones.dat');
    reset(arq_tel);
    if IOResult <> 0 then
    begin
    	Rewrite(arq_tel);
    	if IOResult <> 0 then
    		abriu := false;
    end;
    // Abertura do arquivo de emails
	assign(arq_email,'emails.dat');
	reset(arq_email);
    if IOResult <> 0 then
    begin
    	Rewrite(arq_email);
    	if IOResult <> 0 then
    		abriu := false;
    end;
    if abriu = true then
    begin
    	// verificando o ultimo id cadastrado do arquivo de pessoas
		if filesize(arq_pes) = 0 then
		begin
			id_p := 0;
			id_e := 0;
			id_t := 0;
		end
		else
		begin
			id_p := maior_id_pessoa(arq_pes);
			// verificando o ultimo id cadastrado do arquivo de emails
			if filesize(arq_email) = 0 then
				id_e := 0
			else
				id_e := maior_id_email(arq_email);
			// verificando o ultimo id cadastrado do arquivo de telefones
			if filesize(arq_tel) = 0 then
				id_t := 0
			else
				id_t := maior_id_tel(arq_tel);
		end;
		window(2,2,70,25);
		textbackground(2);
		textcolor(15);
		clrscr;
		for i := 1 to 2 do
		begin
			gotoxy(25,10);clreol;
			write('Iniciando O Sistema.');
			delay(500);
			gotoxy(25,10);clreol;
			write('Iniciando O Sistema..');
			delay(500);
			clreol;
			gotoxy(25,10);clreol;
			write('Iniciando O Sistema...');
			delay(500);
			clreol;
		end;
		repeat												// menu iniciar	
			clrscr;
			borda;
			gotoxy(20,4);writeln('     Agenda Eletrônica');
			gotoxy(19,5);writeln('____________________________');
			gotoxy(20,6);writeln('       Menu Iniciar');
			gotoxy(19,7);writeln('____________________________');
			gotoxy(22,9);writeln('1 - Adicionar Contatos');
			gotoxy(22,10);writeln('2 - Consultar Dados');
			gotoxy(22,11);writeln('3 - Excluir Dados');
			gotoxy(22,12);writeln('0 - Sair');
			gotoxy(12,21);writeln('IFET 2013 - CÂMPUS BARBACENA');
		    gotoxy(12,22);writeln('DANIEL MELO');
			gotoxy(22,14);write('Digite Sua Opção: ');
			gotoxy(22,41);opcao := readkey;
			clrscr;
			case opcao of 		//menu de insercao de dados'
				'1':repeat
						clrscr;
						borda;
						gotoxy(24,4);writeln('    Agenda Eletrônica');
						gotoxy(19,5);writeln('_________________________________');
						gotoxy(22,6);writeln(' Menu de Inserção de dados');
						gotoxy(19,7);writeln('_________________________________');
						gotoxy(22,9);writeln('1 - Adicionar Nome');			// menu secundario
						gotoxy(22,10);writeln('2 - Adicionar Telefone');
						gotoxy(22,11);writeln('3 - Adicionar E-mail');
						gotoxy(22,12);writeln('0 - Retornar Ao Menu Iniciar');
						gotoxy(22,14);write('Digite Sua Opção: ');
						gotoxy(22,41);opcao := readkey;
						clrscr;
						case opcao of
							'1':cad_pessoa(arq_pes);	// cadastrar pessoas
							'2':if id_p = 0 then   // Cadastrar telefones
								begin
									borda;
									gotoxy(23,12);writeln('Nenhum Contato Cadastrado!');
									gotoxy(49,12);delay(3000);
								end
								else
								begin
									listagem(arq_pes);
									gotoxy(24,22);write('Pressione "0" Para Cancelar...');
									gotoxy(25,20);write('Digite o Id Desejado: ');
									gotoxy(47,20);readln(cod);
									if cod > 0 then
										cad_tel(arq_pes,arq_tel,cod)
									else
									begin
										clrscr;
										borda;
										gotoxy(20,12);writeln('Operação Cancelada Pelo Usuário...');
										gotoxy(51,12);delay(3000);
									end;
								end;
							'3':if id_p = 0 then	//Cadastrar emails
								begin
									borda;
									gotoxy(23,12);writeln('Nenhum Contato Cadastrado!');
									gotoxy(49,12);delay(3000);
								end
								else
								begin
									listagem(arq_pes);
									gotoxy(24,22);write('Pressione "0" Para Cancelar...');
									gotoxy(25,20);write('Digite O Id Desejado: ');
									gotoxy(47,20);readln(cod);
									if cod <> 0 then
										cad_email(arq_pes,arq_email,cod)
									else
									begin
										clrscr;
										borda;
										gotoxy(20,12);writeln('Operação Cancelada Pelo Usuário...');
										gotoxy(51,12);delay(3000);
									end;
								end;
						end; // Fim do case de inserção de dados
					until opcao = '0'; 	// fim da opcao 1
			    '2':if id_p = 0 then			//Consultar contatos cadastrados
					begin
						borda;
						gotoxy(23,12);writeln('Nenhum Contato Cadastrado!');
					    gotoxy(49,12);delay(3000);
					end
					else
					begin
						listagem(arq_pes);
						gotoxy(23,22);write('Pressione "0" Para Cancelar..');
						gotoxy(25,20);write('Digite o Id Desejado: ');
						gotoxy(47,20);readln(cod);
						if cod > 0 then
						begin
							consulta(arq_pes,arq_email,arq_tel,cod);
							gotoxy(21,22);write('Pressione Uma tecla Para Continuar');
	    					gotoxy(55,22);readln;
						end
						else
						begin
							clrscr;
							borda;
							gotoxy(20,12);writeln('Operação Cancelada Pelo Usuário...');
							gotoxy(55,12);delay(3000);
						end;
					end; // fim opcao 2
			    '3':if id_p = 0 then
					begin
						borda;
						gotoxy(23,12);writeln('Nenhum Contato Cadastrado!');
						gotoxy(49,12);delay(3000);
					end
					else
					begin
						repeat							// menu de exclusão de dados
							clrscr;
							borda;
							gotoxy(22,4);writeln('    Agenda Eletrônica');
							gotoxy(17,5);writeln('__________________________________');
							gotoxy(20,6);writeln(' Menu De Exclusão De Dados');
							gotoxy(17,7);writeln('__________________________________');
							gotoxy(19,9);writeln('1 - Excluir Todos Os Dados de Um Contato');
							gotoxy(19,10);writeln('2 - Excluir Telefone de Um Contato');
							gotoxy(19,11);writeln('3 - Excluir E-mail de Um Contato');
							gotoxy(19,12);writeln('4 - Excluir Todos Os Contatos');
							gotoxy(19,13);writeln('0 - Retornar Ao Menu Iniciar');
							gotoxy(19,15);write('Digite Sua Opção: ');
							gotoxy(19,41);opcao := readkey;
							clrscr;
							borda;
							case opcao of
								'1':if (id_p = 0) and (id_t = 0) and (id_e = 0) then	//Excluir um contato caso exista
									begin
										borda;
										gotoxy(23,12);writeln('Nenhum Contato Cadastrado!');
										gotoxy(49,12);delay(3000);
									end
									else
									begin
										listagem(arq_pes);
									   	gotoxy(24,22);write('Pressione "0" Para Cancelar...');
										gotoxy(25,20);write('Digite o Id Desejado: ');
										gotoxy(47,20);readln(cod);
										if cod <> 0 then
										begin
											consulta(arq_pes,arq_email,arq_tel,cod);
											deletar_pes(arq_pes,arq_tel,arq_email,cod);
										end
										else
										begin
											clrscr;
											borda;
											gotoxy(20,12);writeln('Operação Cancelada Pelo Usuário...');
											gotoxy(53,12);delay(3000);
										end;
									end; // Fim da opção 1
								'2':if id_t = 0 then				//Excluir telefones caso exista
									begin
										borda;
										gotoxy(23,12);writeln('Nenhum Telefone Cadastrado!');
										gotoxy(49,12);delay(3000);
									end
									else
									begin
										listagem(arq_pes);
										gotoxy(24,22);write('Pressione "0" Para Cancelar...');
										gotoxy(25,20);write('Digite o Id Desejado: ');
										gotoxy(47,20);readln(cod);
										if cod <> 0 then
										begin
											consulta(arq_pes,arq_email,arq_tel,cod);
											achou := false;
											seek(arq_tel,0);
											while (eof(arq_tel) = false) and (achou = false) do
											begin
												read(arq_tel,r_tel);
												if r_tel.id = cod then
													achou := true;
											end;
											if achou = true then
											begin
												gotoxy(23,22);write('Pressione Enter Para Cancelar...');
												gotoxy(20,19);write('Digite O Telefone Que Deseja Excluir: ');
												gotoxy(32,20);readln(tel);
												if tel <> '' then
													if del_tel(arq_tel,cod,tel) = 1 then
													begin
														clrscr;
														borda;
														gotoxy(21,12);writeln('Telefone Deletado Com Sucesso!!');
														gotoxy(52,12);delay(3000);
													end
													else
													begin
														clrscr;
														borda;
														gotoxy(24,12);writeln('Telefone Não Encontrado!');
														gotoxy(48,12);delay(3000);
													end
												else
												begin
													clrscr;
													borda;
													gotoxy(20,12);writeln('Operação Cancelada Pelo Usuário...');
													gotoxy(58,12);delay(3000);
												end;
											end
											else
											begin
												clrscr;
												borda;
												gotoxy(12,12);writeln('Este Contato Não Possui Telefones Cadastrados!');
												gotoxy(56,12);delay(3000);
											end;
										end
										else
										begin
											clrscr;
											borda;
											gotoxy(20,12);writeln('Operação Cancelada Pelo Usuário...');
											gotoxy(56,12);delay(3000);
										end;
									end; // fim da opção 2
								'3':if id_e = 0 then		// Excluir emails de usuarios caso exista
									begin
										clrscr;
										borda;
										gotoxy(23,12);writeln('Nenhum E-mail Cadastrado!');
										gotoxy(49,12);delay(3000);
									end
									else
									begin
										listagem(arq_pes);
										gotoxy(24,22);write('Pressione "0" Para Cancelar...');
										gotoxy(25,20);write('Digite o Id Desejado: ');
										gotoxy(47,20);readln(cod);
										if cod <> 0 then
										begin
											consulta(arq_pes,arq_email,arq_tel,cod);
											achou := false;
											seek(arq_email,0);
											while (eof(arq_email) = false) and (achou = false) do
											begin
												read(arq_email,r_email);
												if r_email.id = cod then
													achou := true;
											end;
											if achou = true then
											begin
												gotoxy(23,22);write('Pressione Enter Para Cancelar...');
												gotoxy(20,19);write('Digite O E-mail Que Deseja Excluir: ');
												gotoxy(23,20);readln(email);												
												if email <> '' then
													if del_email(arq_email,cod,email) = 1 then
													begin
														clrscr;
														borda;
														gotoxy(24,12);writeln('E-mail Deletado Com Sucesso!!');
														gotoxy(48,12);delay(3000);
													end
													else
													begin
														clrscr;
														borda;
														gotoxy(24,12);writeln('E-mail Não Encontrado!');
														gotoxy(48,12);delay(3000);
													end
												else
												begin
													clrscr;
													borda;
													gotoxy(20,12);writeln('Operação Cancelada Pelo Usuário...');
													gotoxy(54,12);delay(3000);
												end;
											end
											else
											begin
												clrscr;
												borda;
												gotoxy(12,12);writeln('Este Contato Não Possui E-mails Cadastrados!');
												gotoxy(56,12);delay(3000);
											end;
										end
										else
										begin
											clrscr;
											borda;
											gotoxy(20,12);writeln('Operação Cancelada Pelo Usuário...');
											gotoxy(53,12);delay(3000);
										end;
									end;
								'4':if id_p > 0 then		//Excluir todos os contatos
									begin
										listagem(arq_pes);
										del_all(arq_pes,arq_tel,arq_email);
									end
									else
									begin
										borda;
										gotoxy(23,12);writeln('Nenhum Contato Cadastrado!');
										gotoxy(49,12);delay(3000);
									end;
							end;	// fim do case de exclusão de dados
						until (opcao = '0') or (id_p = 0);
					end;
				'0':begin
						sair := 'S';
						for i := 1 to 2 do
						begin
							gotoxy(25,10);clreol;
							write('Encerrando O Sistema.');
							delay(500);
							gotoxy(25,10);clreol;
							write('Encerrando O Sistema..');
							delay(500);
							clreol;
							gotoxy(25,10);clreol;
							write('Encerrando O Sistema...');
							delay(500);
							clreol;
						end;
					end;
			end;		// fim do case principal
		until sair = 'S';
		clrscr;
		close(arq_pes);
		close(arq_email);
		close(arq_tel)
	end
	else
	begin
		writeln('Erro Ao Abrir O Arquivo!');
		gotoxy(49,12);delay(3000);
	end;
end.
