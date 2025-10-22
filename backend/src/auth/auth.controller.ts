import { Controller, Post, Body } from '@nestjs/common';
import { AuthService } from './auth.service';

// DTO pour recevoir les données du login
class LoginDto {
  email: string;
  password: string;
}

@Controller('auth') // Toutes les routes de ce controller commenceront par /auth
export class AuthController {
  constructor(private authService: AuthService) {} // Injection du service Auth

  /**
   * Route POST /auth/login
   * @param loginDto - objet contenant email et password
   * @returns access_token si identifiants valides
   */
  @Post('login')
  async login(@Body() loginDto: LoginDto) {
    // Valide l'utilisateur avec le service
    const user = await this.authService.validateUser(
      loginDto.email,
      loginDto.password,
    );

    // Génère le JWT et le renvoie
    return this.authService.login(user);
  }
}
