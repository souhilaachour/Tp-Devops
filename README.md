\# TP DevOps - Atelier CI GitHub Actions



!\[CI](https://github.com/souhilaach-Devops/actions/workflows/ci.yml/badge.svg



\## Description



Ce projet met en œuvre un pipeline CI avec GitHub Actions.



Le pipeline :



\- Se déclenche sur Push et Pull Request

\- Exécute un contrôle qualité avec Flake8

\- Lance les tests Pytest

\- Teste plusieurs versions de Python (3.10, 3.11, 3.12)

\- Utilise un cache des dépendances pip

\- Génère un rapport de couverture conservé en artifact

