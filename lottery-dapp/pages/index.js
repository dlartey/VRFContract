import { useState, useEffect } from 'react'
import Head from 'next/head'
import Web3 from 'web3'
// This references the installed module from web3
import { Inter } from 'next/font/google'
import styles from '@/styles/Home.module.css'
import 'bulma/css/bulma.css'
import Link from 'next/link';

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
              <h1>Lottery dApp</h1>
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

                <div class="card mt-5 has-background-link">
                  <div class="card-content">
                    <div class="content has-text-light">
                      <Link class="has-text-light" href="/keccak">Keccak VRF Lottery</Link>
                    </div>
                  </div>
                </div>

                <div class="card mt-5 has-background-link">
                  <div class="card-content">
                    <div class="content has-text-light">
                      <Link class="has-text-light" href="/vrf1">Chainlink VRF Lottery (1 random word)</Link>
                
                    </div>
                  </div>
                </div>

                <div class="card mt-5 has-background-link">
                  <div class="card-content">
                    <div class="content has-text-light">
                      <Link class="has-text-light" href="/vrf10">Chainlink VRF Lottery (5 random words)</Link>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </section>
        </div>
      </main>
    </>
  )
}
