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
    XCTAssertThrowsError(try leiloeiro.avalia(leilao: leilao), "Não é possível avaliar leilão sem lances") { (error) in
        print(error.localizedDescription)
    }
}
```
