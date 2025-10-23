import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@Injectable() // peut être injecté dans d'autres classes
export class AuthService {
  // 🔹 Simule une base de données en RAM avec un utilisateur exemple
  private users = [
    { id: 1, email: 'test@rociny.com', password: 'test' },
  ];

  
  // 🔹 Injection du JwtService pour créer des tokens JWT
  constructor(private jwtService: JwtService) {}

  /**
   * 🔹 Vérifie si l'utilisateur existe et si le mot de passe correspond
   * @param email - Email fourni par le frontend
   * @param password - Mot de passe fourni par le frontend
   * @returns l'utilisateur sans le mot de passe si OK
   * @throws UnauthorizedException si les identifiants sont invalides
   */
  async validateUser(email: string, password: string): Promise<any> {
    // 🔹 Cherche l'utilisateur dans la "DB" simulée
    const user = this.users.find(
      (u) => u.email === email && u.password === password,
    );

    // 🔹 Si aucun utilisateur correspondant, renvoie une erreur
    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }

    // 🔹 On ne renvoie pas le mot de passe pour des raisons de sécurité
    const { password: _, ...result } = user;
    return result;
  }

  /**
   * 🔹 Génère un JWT pour un utilisateur validé
   * @param user - l'utilisateur validé (id et email)
   * @returns un objet contenant l'access_token
   */
  async login(user: any) {
    // 🔹 Création du payload pour le JWT
    const tokenData = { email: user.email, sub: user.id };

    // 🔹 Génération du token JWT
    return {
      access_token: this.jwtService.sign(tokenData),
    };
  }
}
