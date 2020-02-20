# iOS TDD e Unit Test

Repositório de estudo sobre implementações de teste com o XC Test, framework nativo do iOS.

## Teste de unidade

Considerando que todo teste automatizado precisa ter:

- um cenário.
- uma ação.
- uma validação.

Exemplo:

```swift
  // cenário
  let leilao = CriadorDeLeilao().para(descricao: "Playstation 4")
                .lance(maria, 250.0)
                .lance(joao, 300.0)
                .lance(jose, 400.0)
                .constroi()

  // ação
  try? leiloeiro.avalia(leilao: leilao)

  // validação
  XCTAssertEqual(250, leiloeiro.menorLance())
  XCTAssertEqual(400, leiloeiro.maiorLance())
```

## Fluxo de trabalho do TDD

O fluxo de trabalho do TDD (Test Driven Development ou Desenvolvimento Orientado a Teste, em português), consiste em três etapas:

- RED: escrever um teste referente a algo que deseja validar no aplicativo, antes da implementação, pois a intenção é que ele falhe.

- GREEN: implementar um código para a funcionalidade que será testada, na forma mais simples possível, para que dê certo e passe no teste.

- REFACTOR: refatorar o código, se houver necessidade para legibilidade e qualidade do código.

Assim, é definido o fluxo de trabalho TDD, essa cultura de desenvolvimento, que inicia com a escrita do teste para depois implementar o código da funcionalidade.

## Test Data Builder

Para facilitar o cenário de desenvolvimento de teste, é criado uma classe Data Builder referente a classe que será testada, assim agilizando processos repetitivos.

Exemplo:

```swift
class CriadorDeLeilao: NSObject {

  private var leilao: Leilao!

  func para(descricao: String) -> Self {
    leilao = Leilao(descricao: descricao)
    return self
  }

  func lance(_ usuario:Usuario, _ valor:Double) -> Self {
    leilao.propoe(lance: Lance(usuario, valor))
    return self
  }

  func constroi() -> Leilao {
    return leilao
  }
}
```

Utilização:

```swift
...

let leilao = CriadorDeLeilao().para(descricao: "Playstation 4")
              .lance(joao, 300.0)
              .lance(maria, 400.0)
              .lance(joao, 500.0 )
              .lance(maria, 600.0).constroi()

    leiloeiro.avalia(leilao: leilao)
...
```

## Testando exceções

Quando trabalhamos com testes, é importante testarmos métodos que lançam exceções. Por exemplo, faz sentido avaliarmos um leilão sem lances? Não faz sentido. Nesse caso, podemos disparar uma exceção nesse método. Em contrapartida, devemos escrever um teste para validar se isso realmente acontece.

Exemplo:

```swift
func avalia(leilao:Leilao) throws {

  if leilao.lances?.count == 0 {
      throw ErroAvaliador.LeilaoSemLance("Não é possível avaliar um leilão sem lances")
  }

  // continuação do método..
}
```

Dessa forma, o método testDeveIgnorarLeilaoSemNenhumLance() ficará da seguinte forma:

```swift
func testDeveIgnorarLeilaoSemNenhumLance() {
    let leilao = CriadorDeLeilao().para(descricao: "Playstation 4").constroi()
    XCTAssertThrowsError(
        try leiloeiro.avalia(leilao: leilao),
        "Não é possível avaliar leilão sem lances"
      ) { (error) in
        print(error.localizedDescription)
    }
}
```

## Mocks

Objetos Mock, objetos simulados ou simplesmente Mock (do inglês Mock object) são objetos que simulam o comportamento de objetos reais de forma controlada. São normalmente criados para testar o comportamento de outros objetos. Em outras palavras, os objetos mock são objetos “falsos” que simulam o comportamento de uma classe ou objeto “real” para que possamos focar o teste na unidade a ser testada.

Exemplo de uso no projeto, para substituir a classe que Dao real que faz a persistência dos dados:

```swift
class LeilaoDaoFalse {

  private var leiloes: [Leilao] = []

  func salva(_ leilao:Leilao) {
    leiloes.append(leilao)
  }

  func encerrados() -> [Leilao] {
    return leiloes.filter { $0.encerrado == true }
  }

  func correntes() -> [Leilao] {
    return leiloes.filter { $0.encerrado == false }
  }

  func atualiza(leilao:Leilao) {}
}

```

## Injeção de dependência

É um padrão de desenvolvimento utilizado quando é necessário manter baixo o
nível de acoplamento entre diferentes módulos. As dependências entre os módulos
não são definidas programaticamente, mas sim "injetado" em cada componente suas
dependências declaradas.

Exemplo:

```swift
class EncerradorDeLeilao {

  private var total = 0

  private var dao: LeilaoDao

  // Injeção da dependência
  init(_ leilaoDao: LeilaoDao) {
    self.dao = leilaoDao
  }

    func encerra() {
        // Em vez de instanciar no método a um objeto LeilaoDao
        // LeilaoDao é injetado na inicialização da classe
        // EncerradorDeLeilao, assim foi injetado a dependência.

        // let dao = LeilaoDao()

        let todosLeiloesCorrentes = dao.correntes()
        for leilao in todosLeiloesCorrentes {
            if comecouSemanaPassada(leilao) {
                leilao.encerra()
                total+=1
                dao.atualiza(leilao: leilao)
            }
    // implementação da classe...

```

## Adicionando pod Cuckoo ao projeto

Pod para agilizar o desenvolvimento de testes, onde o pod cria a classe de Mock
que será testada.

[https://github.com/Brightify/Cuckoo](https://github.com/Brightify/Cuckoo)

Criar Mocks:

- Instalar via cocoaPods

- Inserir script no Build Phases

- Instanciar classe que será mockada

```swift
let avaliadorFalso = Avaliador()
```

## Ensinando o Mock a responder conforme o esperado

Quando o método .encerrados() for chamado, o mock irá retornar imadiatamente o
valor dentro de .thenReturn(...)

Exemplo:

```swift
let daoFalso = MockLeilaoDao().withEnabledSuperclassSpy()

stub(daoFalso) { (daoFalso) in
  when(daoFalso.encerrados()).thenReturn([playStation])
}
```

## Verify

Verifica se o método foi chamado:

```swift
// dentro do método encerra() será invocado o método .atualiza()
encerradorDeLeilao.encerra()

// o verify irá testar se o método .atualiza() foi invocado
verify(daoFalso).atualiza(leilao: tvLed)
```

## Métodos que lançam exceções

```swift
let error = NSError(domain: "Error", code: 0, userInfo: nil)

stub(daoFalso) { (daoFalso) in
  when(daoFalso.correntes()).thenReturn([tvLed, geladeira])
  // força o mock a retornar o erro
  when(daoFalso.atualiza(leilao: tvLed)).thenThrow(error)
}
```

## Capturando argumento durante o fluxo dos dados

```swift
// ...
let playStation = CriadorDeLeilao().para(descricao: "Playstation")
    .lance(Usuario(nome: "José"), 2000.0)
    .lance(Usuario(nome: "Maria"), 2500.0)
    .constroi()

let daoFalso = MockLeilaoDao().withEnabledSuperclassSpy()

stub(daoFalso) { (daoFalso) in
  when(daoFalso.encerrados()).thenReturn([playStation])
}

let avaliadorFalso = Avaliador()

let pagamentos = MockRepositorioDePagamento().withEnabledSuperclassSpy()

let geradorDePagamento = GeradorDePagamento(daoFalso, avaliadorFalso, pagamentos)
geradorDePagamento.gera()

// instancia o objeto que irá capturar um atributo
let capturadorDeArgumento = ArgumentCaptor<Pagamento>()

// passa como parametro o capturador
verify(pagamentos).salva(capturadorDeArgumento.capture())

// compara o valor capturado com o esperado
let pagamentoGerado = capturadorDeArgumento.value
XCTAssertEqual(2500.0, pagamentoGerado?.getValor())
```
