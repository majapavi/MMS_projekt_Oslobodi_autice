Prijedlozi za dorade / poboljšanja:
 - Dodati display state u koji igrica dolazi nakon što je izgubio sve živote na nekom nivou
 - Dodati zvuk
 - Dodati glazbu
 - Dodati odgovarajuće mute buttone
 - Refaktorirati klase navigacijskih gumba tako da ostane samo bazna klasa,
   a funkcije koje se izvršavaju na klik prosljeđivati kao parametar u konstruktoru
 - Gumb za "pokretanje" nivoa (na početku je nivo pauziran)
 - Estetski doraditi sučelje 
   - dodati pozadinu na pojedine display-eve, urediti gumbe
   - nacrtati semafore, pješake, prepreke
   - urediti pločnik, npr. dodati drveće
 - Vidjeti više informacija o pojedinom auto ako se klikne na njega
   kad je pauzirana igra
 - Animacije (prilikom sudara)
 - Poboljšati collision box-eve kod skretanja
 - Vizualni prikaz što igrač može kliknuti (na tutorial nivoima)
 - Poboljšati redoslijed crtanja nivoa (Z-index ili mijenjanje gdje
   se draw funkcije pozivaju).
 - Garaže - jedan autić može ući u nju i onda se broji kao da je izašao
   iz nivoa, poslije toga se gleda kao zid (hazard)
 - Postavka odabira težine (težina = brzina igre)
 - Prikazati gdje se dogodio sudar pa tek onda resetirati nivo
 - Pamćenje napretka igrača u lokalni file
 - Pamćenje koliko je puta igrač izgubio
 - Tajmer koliko je vremena igraču trebalo da prijeđe nivo
 - Refaktoriranje koda:
   - Preimenovati Wall u nešto smislenije
   - Preimenovati ostale loše nazvane klase/funkcije/atribute
   - Estetski poboljšati kod i osigurati standard
 - Dodati još zanimljivih nivoa
 - Pojednostaviti rađenje nivoa
 - Beskonačni nivoi gdje se novi autići stalno stvaraju, a cilj je
   preživjeti što duže bez sudaranja
