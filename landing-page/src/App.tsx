import React from 'react';
import logo from './logo.png';
import styles from './App.module.scss';

function App() {
  return (
    <div className={styles.App}>
      <header className={styles.AppHeader}>
        <h1>
          food waste is bananas.
        </h1>
        <div className={styles.bananas}>
          <img src={logo} className={styles.AppLogo} alt="logo" />
          <img src={logo} className={styles.AppLogoCounter} alt="logo" />
          <img src={logo} className={styles.AppLogo} alt="logo" />
        </div>
        <p>
          we <a className={styles.AppLink} href="">can do something</a> about it.
        </p>
      </header>
    </div>
  );
}

export default App;
