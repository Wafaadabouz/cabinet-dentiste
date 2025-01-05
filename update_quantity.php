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

// Vérifier si le formulaire est soumis
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['quantite'])) {
    $id = $_POST['id'];  // ID du produit à mettre à jour
    $quantite = $_POST['quantite'];  // Quantité à décrémenter (entrée par l'utilisateur)
    $nom_produit = $_POST['nom_produit'];  // Nom du produit

    // Rechercher l'élément dans la base de données
    $sql = "SELECT * FROM stock WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $product = $result->fetch_assoc();
        $new_quantity = $product['quantite'] - $quantite;

        // Si la nouvelle quantité est inférieure à 10, envoyer un email de notification
        if ($new_quantity < 10) {
            sendNotificationEmail($nom_produit);
        }

        // Mettre à jour la quantité dans la base de données
        $update_sql = "UPDATE stock SET quantite = ? WHERE id = ?";
        $update_stmt = $conn->prepare($update_sql);
        $update_stmt->bind_param("ii", $new_quantity, $id);
        $update_stmt->execute();

        // Rediriger vers la page de gestion du stock
        header("Location: stock.php");
        exit();
    } else {
        echo "Produit non trouvé dans le stock.";
    }
} else {
    echo "Quantité non spécifiée.";
}

// Fonction pour envoyer une notification par email
function sendNotificationEmail($productName) {
    $to = "wafaaitc@gmail.com"; // L'adresse e-mail de notification
    $subject = "Alerte Stock - Produit en quantité faible";
    $message = "Le produit " . $productName . " est maintenant en quantité inférieure à 10. Veuillez le réapprovisionner.";
    $headers = "From: no-reply@votre-domaine.com";

    mail($to, $subject, $message, $headers);
}

// Fermer la connexion
$conn->close();
?>
