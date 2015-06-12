Das Berechnen der einzelnen Elemente des potenziellen Lösungsvektors einer
Iteration kann leicht parallelisisert werden. Da die einzelnen Elemente
unabhängig voneinander berechnet werden können, kann man den Vektor zum Beispiel
in zwei Hälften von 512 Elementen aufteilen und diese in unterschiedlichen
Threads berechnen lassen. Ein weiterer Thread würde auf die Fertigstellungen
dieser Berechnungen warten und dann überprüfen, ob die neue Lösung genau genug
ist. 

Eine simple Implementierung (mit der phtreads-API) würde in jeder Iteration neue Threads erstellen, die
einen Teil des neues Vektors berechnen und auf deren Terminierung in der
Hauptfunktion mittels `phtread_join` gewartet wird. Das würde allerdings in der
Praxis möglicherweise nur einen geringen Zeitgewinn bringen, da das Erstellen
eines Threads üblicherweise eine aufwändige Operation ist.

Mithilfe der `phtread_cond*`-Funktionen wäre auch eine Synchronisation von
Threads, die über die Iterationen beständig sind, möglich. Dazu könnte für jeden
Thread jeweils eine Konditionsvariable benutzt werden, mit der der Hauptthread
den entsprechenden Teil des Vektors zur Berechnung `freigibt`; sowie eine
Variable, mit der dieser Thread die Fertigstellung der Berechnung signalisiert.
Dafür wären auch enstprechende Mutexe nötig.

Die Benutzung der SSE-Instruktionen ist vergleichsweise einfach; aktuelle
Versionen von GCC benutzen, wenn gewollt, automatisch diese Instruktionen.
Alternativ kann man auch mit Inline-Assembler die Instruktionen manuell
benutzen. So kann man die nötigen Operationen, etwa das Berechnen des Quadrats
der Differenz der Elemente bei der euklidischen Distanz, immer für zwei Elemente
gleichzeitig ausführen.
