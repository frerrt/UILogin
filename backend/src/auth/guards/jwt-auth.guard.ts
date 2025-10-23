import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

// Le nom 'jwt' doit correspondre au nom que vous avez donné à votre JwtStrategy (généralement 'jwt').
@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}