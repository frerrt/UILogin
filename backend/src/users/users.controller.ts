// backend/src/users/users.controller.ts

import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('users')
export class UsersController {
  
  // Cette route est maintenant protégée par le Guard JWT.
  @UseGuards(JwtAuthGuard)
  @Get('profile')
  getProfile(@Request() req) {
    // Si le code atteint cette ligne, le JWT est valide.
    // req.user contient le payload du JWT (l'ID et l'email de l'utilisateur).
    return {
      message: 'Félicitations ! Vous avez accédé à la ressource sécurisée.',
      userData: req.user,
    };
  }
}