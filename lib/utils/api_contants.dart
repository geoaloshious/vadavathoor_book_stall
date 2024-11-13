// const baseURL = 'http://localhost:3000';
// const baseURL =
//     'http://ec2-13-234-66-205.ap-south-1.compute.amazonaws.com:3000';

class ApiConstants {
  static const String baseURL = bool.fromEnvironment('dart.vm.product')
      ? 'http://ec2-13-234-66-205.ap-south-1.compute.amazonaws.com:3000'
      : 'http://localhost:3000';
}

class EndPoints {
  static const upSync = '/upsync';
  static const downSync = '/downsync';
  static const reportError = '/report-error';
}
