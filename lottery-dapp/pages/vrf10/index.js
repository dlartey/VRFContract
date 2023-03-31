// Reference: https://github.com/jspruance/block-explorer-tutorials/blob/main/apps/Lottery/lottery-dapp/pages/index.js
// Reference: https://www.youtube.com/watch?v=8ElPDw0laIo&t=10522s
// Lines 5-352

import { useState, useEffect } from 'react'
import Head from 'next/head'
import Web3 from 'web3'
import lotteryContract from '../../blockchain/lottery10'
// This references the installed module from web3
import { Inter } from 'next/font/google'
import styles from '@/styles/Home.module.css'
import 'bulma/css/bulma.css'
const inter = Inter({ subsets: ['latin'] })

export default function Home() {

  const [web3, setWeb3] = useState()
  const [address, setAddress] = useState()
  //local contract copy
  const [lcContract, setLcContract] = useState()
  // lottery pot react variable
  const [lotteryPot, setLotteryPot] = useState()
  const [lotteryPlayers, setPlayers] = useState([])
  const [lotteryHistory, setLotteryHistory] = useState([])
  const [lotteryId, setLotteryId] = useState()
  const [error, setError] = useState('')
  const [success, setSuccessMsg] = useState('')
  // Calls the wallet handler when it is clicked by the button
  // Metamask injects a wallet provider under the window object

  useEffect(() => {
    updateState()
  }, [lcContract])


  const updateState = () => {
    if (lcContract) getPot()
    if (lcContract) getPlayers()
    if (lcContract) getLotteryId()
  }
  const getPot = async () => {
    // Read only
    const pot = await lcContract.methods.getBalance().call()
    setLotteryPot(web3.utils.fromWei(pot, 'ether'))
  }

  const getPlayers = async () => {
    // Read only
    const players = await lcContract.methods.getPlayers().call()
    setPlayers(players)
  }

  const getHistory = async (id) => {
    setLotteryHistory([])
    for (let i = parseInt(id); i > 0; i--) {
      console.log('get history')
      const winner = await lcContract.methods.lotteryHistory(i).call()
      const historyObj = {}
      historyObj.id = i
      historyObj.address = winner
      setLotteryHistory(lotteryHistory => [...lotteryHistory, historyObj])
    }

    // const history = await lcContract.methods.lotteryHistory().call()
    // setLotteryHistory(history)
  }

  const getLotteryId = async () => {
    const lotteryId = await lcContract.methods.lotteryId().call()
    setLotteryId(lotteryId)
    await getHistory(lotteryId)
    console.log(JSON.stringify(lotteryHistory))
  }

  // Handler to enter lottery (check to ensure user can't enter more than once)
  const enterLotteryHandler = async () => {
    setError('')
    try {
      await lcContract.methods.enter().send({
        from: address,
        value: '15000000000000000',
        gas: 300000,
        gasPrice: null
      })
      updateState()
    } catch (err) {
      setError(err.message)
    }

  }

  // 1:56 rewatch this
  const pickWinnerHandler = async () => {
    setError('')
    setSuccessMsg('')

    console.log(`address from pick winner:: ${address}`)
    // const p = await lcContract.methods.players(1).call()
    // console.log(p)
    const startTime = performance.now()
    try {
      await lcContract.methods.requestRandomWords().send({
        from: address,
        gas: 300000,
        gasPrice: null
      })
      const endTime = performance.now()
      setSuccessMsg(`Random Number Generated. Time taken: ${endTime - startTime} milliseconds`)
      const date = new Date(endTime-startTime);
      console.log(`${date.getMinutes()}:${date.getSeconds()}`)

    } catch (err) {
      setError(err.message)
    }

  }

  const payWinnerHandler = async () => {
    setError('')
    setSuccessMsg('')
    const lrqid =  await lcContract.methods.lastRequestId().call()
    const rands = await lcContract.methods.s_requests(lrqid).call()
    console.log(rands)
    //setSuccessMsg(rands)
    //setSuccessMsg(req[lrqid].randomWords)
    const startTime = performance.now()
    try {
      await lcContract.methods.payWinner().send({
        from: address,
        gas: 300000,
        gasPrice: null
      })
      const endTime = performance.now()
      setSuccessMsg(`Winner paid. Time taken: ${endTime - startTime} milliseconds`)
      const date = new Date(endTime-startTime);
      console.log(`${date.getMinutes()}:${date.getSeconds()}`)

      console.log(`lottery id :: ${lotteryId}`)
      const winnerAddress = await lcContract.methods.lotteryHistory(lotteryId).call()
      setSuccessMsg(`The winner is ${winnerAddress}`)
      updateState()
    } catch (err) {
      setError(err.message)
      console.log(err)
    }

  }

  const connectWalletHandler = async () => {
    setError('')
    // Checks if we are in a browser environment and metamask installed
    if (typeof window !== "undefined" && typeof window.ethereum !== "undefined") {

      // Attempt to connect to metamask
      try {
        // Request wallet connection & set to state
        // Calling a request on the ETH wallet provider injected into the window
        await window.ethereum.request({ method: "eth_requestAccounts" })
        // Create web3 instance & use it to invoke methods on smart contract

        // Set web3 instance in react state
        const web3 = new Web3(window.ethereum)
        setWeb3(web3)

        // Get list of accounts
        const accounts = await web3.eth.getAccounts()
        // Set account 1 to React state
        setAddress(accounts[0])

        // Create local contract copy
        const lc = lotteryContract(web3)
        // want to set this into a react state variable
        setLcContract(lc)

        window.ethereum.on('accountsChanged', async () => {
          const accounts = await web3.eth.getAccounts()
          console.log(accounts[0])
          /* set account 1 to React state */
          setAddress(accounts[0])
        })
      } catch (err) {
        setError(err.message)
      }
    } else {
      setError("Install Metamask")
    }
  }

  // This is one function
  return (
    <>
      <Head>
        <title>Chainlink VRF Lottery dApp</title>
        <meta name="description" content="A simple smart contract to benchmark how long it takes Chainlink VRF to produce randomness" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        {/*  // 2 columns for main interface
        // 1/3 of a grid for a sidebar
        */}
        <nav className='navbar is-link'>
          <div className='container'>
            <div className='navbar-brand'>
              <h1>Chainlink VRF Lottery</h1>
            </div>
            <div className='navbar-end mt-4'>
              {/* When button clicked it uses javascript function defined above */}
              <button onClick={connectWalletHandler} className='button is-dark'>
                Connect Wallet
              </button>
            </div>
          </div>
        </nav>

        <div className='container'>
          {/*  // 3 buttons Enter & Choose Winner & Pick Winner */}
          <section className='mt-4'>
            <div className='columns'>
              {/* Used for entering the lottery & picking the winner */}
              <div className='column is-two-thirds'>
                {/* Separate buttons into sections */}

                <div className='card has-background-link'>
                  <div className='card-content mt-4 has-text-light'>
                  <p>Contract address for VRF: 0x78761F4B128Ab2f4abBeecb4c8af68B20E0B30f1</p>
                    <p>Enter Lottery (0.01 ETH required)</p>
                    <button onClick={enterLotteryHandler} className='button is-dark is-large mt-3'>
                      Enter
                    </button>
                  </div>
                </div>

               
                {/* Button to Select the winner for the contract Owner */}

                <div className='card has-background-link'>
                  <div className='card-content mt-4 has-text-light'>
                    <p><b>Admin only:</b> Pick winner</p>
                    <button onClick={pickWinnerHandler} className='button is-danger is-large mt-3'>
                      Pick Winner
                    </button>
                  </div>
                </div>

                <div className='card has-background-link'>
                  <div className='card-content mt-4 has-text-light'>
                    <p><b>Admin only:</b> Pay winner</p>
                    <button onClick={payWinnerHandler} className='button is-danger is-large mt-3'>
                      Pay Winner
                    </button>
                  </div>
                </div>


                {/* Error message part */}
                <section>
                  <div className='container has-text-danger mt-6'>
                    <p>{error}</p>
                  </div>
                </section>


                {/* Success message part */}
                <section>
                  <div className='container has-text-success mt-6'>
                    <p>{success}</p>
                  </div>
                </section>
              </div>

              {/* Shows information about lottery pot & history */}
              <div className={`${styles.lotteryinfo} column is-one-third`}>
                {/* Consists of Lottery History, Lottery Pot & Lottery Players */}
                <section className='mt-5'>
                  {/* Bulma class to style the information */}
                  <div className='card has-background-link has-text-light'>
                    <div className='card-content'>
                      <div className='content'>
                        <h2 className='has-text-light'>Lottery History</h2>
                        {/* Custom className */}

                        {
                          (lotteryHistory && lotteryHistory.length > 0) && lotteryHistory.map(item => {
                            if (lotteryId != item.id) {
                              return <div className='history-entry mt-3' key={item.id}>
                                <div className='has-text-light'> Lottery #{item.id} Winner:</div>
                                <div>
                                  <a className='has-text-light' href={`https://goerli.etherscan.io/address/${item.address}`} target='_ '>
                                    {item.address}
                                  </a>
                                </div>
                              </div>
                            }

                          })
                        }

                      </div>
                    </div>
                  </div>
                </section>

                {/* Second Bulma Card */}
                <section className='mt-5'>
                  <div className='card has-background-link has-text-light'>
                    <div className='card-content'>
                      <div className='content'>
                        <h2 className='has-text-light'>Current Players (Addresses)</h2>
                        {/* Custom className & iterate over players*/}
                        <ul className='ml-0'>
                          {
                            (lotteryPlayers && lotteryPlayers.length > 0) && lotteryPlayers.map((player, index) => {
                              return <li key={`${player}-${index}`}>
                                <a className='has-text-light' href={`https://goerli.etherscan.io/address/${player}`} target='_blank'>
                                  {player}
                                </a>
                              </li>
                            })
                          }
                        </ul>
                      </div>
                    </div>
                  </div>
                </section>

                {/* Third Bulma Card */}
                <section className='mt-5'>
                  <div className='card has-background-link'>
                    <div className='card-content'>
                      <div className='content'>
                        <h2 className='has-text-light'>Current Contract Balance</h2>
                        {/* Custom className */}
                        <div className='history-entry has-text-light'>
                          <p> {lotteryPot} ETH</p>
                        </div>
                      </div>
                    </div>
                  </div>
                </section>

              </div>
            </div>


          </section>
        </div>
      </main>
    </>
  )
}
