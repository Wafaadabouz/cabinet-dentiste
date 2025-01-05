<?php
// Connexion à la base de données MySQL
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "cabinet";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Fonction pour envoyer un email
function sendNotificationEmail($productName) {
    $to = "wafaaitc@gmail.com"; // L'adresse e-mail de notification
    $subject = "Alerte Stock - Produit en quantité faible";
    $message = "Le produit " . $productName . " est maintenant en quantité inférieure à 10. Veuillez le réapprovisionner.";
    $headers = "From: no-reply@votre-domaine.com";

    mail($to, $subject, $message, $headers);
}

// Récupérer les données du formulaire pour ajouter un produit
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['add_product'])) {
    $nom_produit = $_POST['nom_produit'];
    $quantite = $_POST['quantite'];
    $prix_unitaire = $_POST['prix_unitaire_hidden'];

    // Vérifier si le produit existe dans la base de données
    $sql = "SELECT * FROM stock WHERE nom_produit = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $nom_produit);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        // Le produit existe, donc on met à jour la quantité
        $product = $result->fetch_assoc();
        $new_quantity = $product['quantite'] + $quantite;

        if ($new_quantity < 10) {
            // Envoyer une notification par email si la quantité est inférieure à 10
            sendNotificationEmail($nom_produit);
        }

        // Mettre à jour la base de données avec la nouvelle quantité
        $update_sql = "UPDATE stock SET quantite = ? WHERE id = ?";
        $update_stmt = $conn->prepare($update_sql);
        $update_stmt->bind_param("ii", $new_quantity, $product['id']);
        $update_stmt->execute();
    } else {
        // Le produit n'existe pas, ajouter le produit
        $sql = "INSERT INTO stock (nom_produit, quantite, prix_unitaire) VALUES (?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("sis", $nom_produit, $quantite, $prix_unitaire);
        $stmt->execute();
    }

    // Rediriger vers une page pour voir les produits après la mise à jour
    header("Location: stock.php");
}

// Récupérer les produits dans la base de données
$sql = "SELECT * FROM stock";
$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Gestion de Stock</title>
    <link rel="stylesheet" href="style.css" />
    <style>
        /* Style pour la ligne avec quantité inférieure à 10 */
        .low-stock {
            background-color: red;
            color: white;
        }

        /* Optionnel: ajouter une couleur rouge pour le texte seulement */
        .low-stock-text {
            color: red;
        }
    </style>
</head>
<body>
    <h1>Gestion du Stock</h1>

    <!-- Formulaire pour ajouter un produit -->
    <form action="stock.php" method="POST">
        <h2>Ajouter/Mettre à jour un produit</h2>
        <label for="nom_produit">Produit :</label>
        <select name="nom_produit" id="nom_produit" onchange="updatePrice()">
            <option value="brosse_a_dents">Brosse à dents</option>
            <option value="dentifrice">Dentifrice</option>
            <option value="fil_dentaire">Fil dentaire</option>
            <option value="bain_de_bouche">Bain de bouche</option>
            <option value="kit_blanchiment">Kit de blanchiment dentaire</option>
            <option value="gel_dents_sensibles">Gel pour dents sensibles</option>
            <option value="cire_orthodontique">Cire orthodontique</option>
            <option value="prothese_dentaire">Prothèse dentaire</option>
            <option value="implant_dentaire">Implant dentaire</option>
            <option value="couronne">Couronne dentaire</option>
            <option value="bridge_dentaire">Bridge dentaire</option>
            <option value="gel_anesthesique">Gel anesthésique</option>
            <option value="gants_jetables">Gants jetables</option>
            <option value="masque_chirurgical">Masque chirurgical</option>
            <option value="pince_dentaire">Pince dentaire</option>
            <option value="composite_dentaire">Composite dentaire</option>
            <option value="ciment_dentaire">Ciment dentaire</option>
            <option value="detartrage_instruments">Instruments de détartrage</option>
            <option value="serum_physio">Sérum physiologique</option>
            <option value="protecteur_dentaire">Préservatif dentaire</option>
            <option value="mousse_polissage">Mousse de polissage</option>
        </select>
        <br /><br />

        <label for="quantite">Quantité :</label><br>
        <input type="number" id="quantite" name="quantite" required /><br><br>

        <label for="prix_unitaire">Prix unitaire (en DZD) :</label>
        <input type="text" id="prix_unitaire" name="prix_unitaire" readonly />
        <input type="hidden" id="prix_unitaire_hidden" name="prix_unitaire_hidden" />

        <input type="submit" name="add_product" value="Ajouter Produit" />
    </form>

    <h2>Liste des produits en stock :</h2>
    <table border="1">
        <thead>
            <tr>
                <th>Nom du produit</th>
                <th>Quantité disponible</th>
                <th>Prix unitaire</th>
                <th>Mettre à jour la quantité</th>
            </tr>
        </thead>
        <tbody>
            <?php while ($row = $result->fetch_assoc()) { ?>
                <tr class="<?php echo ($row['quantite'] < 10) ? 'low-stock' : ''; ?>">
                    <td><?php echo $row['nom_produit']; ?></td>
                    <td>
                        <?php echo $row['quantite']; ?>
                        <?php if ($row['quantite'] < 10) { ?>
                            <span class="low-stock-text"> - Attention : Stock faible!</span>
                        <?php } ?>
                    </td>
                    <td><?php echo $row['prix_unitaire']; ?> DZD</td>
                    <td>
                        <!-- Formulaire pour mettre à jour la quantité d'un produit -->
                        <form action="update_quantity.php" method="POST">
                            <input type="hidden" name="id" value="<?php echo $row['id']; ?>" />
                            <input type="hidden" name="nom_produit" value="<?php echo $row['nom_produit']; ?>" />
                            <input type="number" name="quantite" value="1" min="1" required />
                            <button type="submit">Mettre à jour</button>
                        </form>
                    </td>
                </tr>
            <?php } ?>
        </tbody>
    </table>

    <script>
        // Liste des prix associés aux produits
        const prix_unitaire = {
            brosse_a_dents: 200,
            dentifrice: 150,
            fil_dentaire: 120,
            bain_de_bouche: 250,
            kit_blanchiment: 500,
            gel_dents_sensibles: 300,
            cire_orthodontique: 100,
            prothese_dentaire: 12000,
            implant_dentaire: 20000,
            couronne: 8000,
            bridge_dentaire: 10000,
            gel_anesthesique: 350,
            gants_jetables: 50,
            masque_chirurgical: 80,
            pince_dentaire: 600,
            composite_dentaire: 400,
            ciment_dentaire: 150,
            detartrage_instruments: 700,
            serum_physio: 30,
            protecteur_dentaire: 250,
            mousse_polissage: 150
        };

        function updatePrice() {
            const nom_produit = document.getElementById("nom_produit").value;
            const prixInput = document.getElementById("prix_unitaire");
            const prixHiddenInput = document.getElementById("prix_unitaire_hidden");

            if (prix_unitaire.hasOwnProperty(nom_produit)) {
                prixInput.value = prix_unitaire[nom_produit] + " DZD";
                prixHiddenInput.value = prix_unitaire[nom_produit];
            } else {
                prixInput.value = "Prix non disponible";
                prixHiddenInput.value = "";
            }
        }

        window.onload = function () {
            updatePrice();
        };
    </script>
</body>
</html>

<?php
// Fermer la connexion
$conn->close();
?>
