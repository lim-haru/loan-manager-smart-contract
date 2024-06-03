# StartToImpact: Loan Manager - Solidity Smart Contract

## Descrizione

`LoanManager` è uno smart contract scritto in Solidity che permette agli utenti di prestare e prendere in prestito fondi tra di loro senza la necessità di intermediari finanziari. Il contratto garantisce trasparenza e sicurezza grazie alla tecnologia blockchain, tracciando tutte le transazioni e garantendo l’integrità del processo di prestito.

### [Presentazione](https://www.canva.com/design/DAGHFp0c9zE/Eb-WsNrLNDL5PSeFezCW4A/view?utm_content=DAGHFp0c9zE&utm_campaign=designshare&utm_medium=link&utm_source=editor)

## Funzionalità

- **Creazione di un prestito**: Gli utenti possono creare un prestito specificando l'importo, il tasso di interesse e la durata.
- **Finanziamento del prestito**: I prestatori possono finanziare i prestiti trasferendo l'importo del prestito al mutuatario.
- **Rimborso del prestito**: I mutuatari possono rimborsare i prestiti pagando il capitale, gli interessi e le eventuali penali.
- **Annullamento del prestito**: I prestiti possono essere annullati dal mutuatario prima che siano finanziati.
- **Calcolo degli interessi**: Calcola l'interesse dovuto in base al tasso di interesse e alla durata del prestito.
- **Calcolo delle penali**: Calcola le penali applicate ai prestiti rimborsati in ritardo.

## Indirizzo del Contratto

Il contratto `LoanManager` è stato distribuito sulla testnet di Sepolia all'indirizzo:

```
0x720cE4BEaA91A4E453a75969726AAeD179B6E16f
```

## Struttura del Progetto

Il progetto è composto dai seguenti file:

- `LoanManager.sol`: Il contratto principale che gestisce la creazione, il finanziamento, il rimborso e l'annullamento dei prestiti.
- `LoanLibrary.sol`: Una libreria per calcolare gli interessi e le penali sui prestiti.

<br>

## Licenza

Questo progetto è rilasciato sotto la licenza MIT.
